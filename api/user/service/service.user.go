package service

import (
	"errors"
	"fmt"
	"regexp"
	"strings"
	"time"

	"github.com/delala/api/common"
	"github.com/delala/api/entity"
	"github.com/delala/api/post"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/nyaruka/phonenumbers"
)

// Service is a type that defines a user service
type Service struct {
	userRepo      user.IUserRepository
	passwordRepo  user.IPasswordRepository
	apiClientRepo user.IAPIClientRepository
	apiTokenRepo  user.IAPITokenRepository
	postRepo      post.IPostRepository
	roleRepo      user.IUserRoleRepository
	commonRepo    common.ICommonRepository
}

// NewUserService is a function that returns a new user service
func NewUserService(userRepository user.IUserRepository,
	passwordRepository user.IPasswordRepository, apiClientRepository user.IAPIClientRepository,
	apiTokenRepository user.IAPITokenRepository, postRepository post.IPostRepository,
	roleRepository user.IUserRoleRepository, commonRepository common.ICommonRepository) user.IService {
	return &Service{userRepo: userRepository, passwordRepo: passwordRepository,
		apiClientRepo: apiClientRepository, apiTokenRepo: apiTokenRepository,
		postRepo: postRepository, roleRepo: roleRepository, commonRepo: commonRepository}
}

// AddUser is a method that adds a new user to the system
func (service *Service) AddUser(newUser *entity.User, newPassword *entity.Password) error {
	err := service.userRepo.Create(newUser)
	if err != nil {
		return errors.New("unable to add new user")
	}

	newPassword.ID = newUser.ID
	err = service.passwordRepo.Create(newPassword)
	if err != nil {
		// Cleaning up if password is not add to the database
		service.userRepo.Delete(newUser.ID)
		return errors.New("unable to add new user")
	}

	return nil
}

// ValidateUserProfile is a method that validate a user profile.
// It checks if the user has a valid entries or not and return map of errors if any.
// Also it will add country code to the phone number value if not included: default country code +251
func (service *Service) ValidateUserProfile(user *entity.User) entity.ErrMap {

	errMap := make(map[string]error)
	isValidFirstName, _ := regexp.MatchString(`^[a-zA-Z]\w*$`, user.FirstName)
	isValidLastName, _ := regexp.MatchString(`^\w*$`, user.LastName)
	isValidUserRole := service.ValidUserRole(user.Role)

	countryCode := tools.GetCountryCode(user.PhoneNumber)
	phoneNumber := tools.OnlyPhoneNumber(user.PhoneNumber)

	// Checking for local phone number
	isLocalPhoneNumber, _ := regexp.MatchString(`^0\d{9}$`, phoneNumber)
	if isLocalPhoneNumber && (countryCode == "" || countryCode == "ET") {
		phoneNumberSlice := strings.Split(phoneNumber, "")
		if phoneNumberSlice[0] == "0" {
			phoneNumberSlice = phoneNumberSlice[1:]
			internationalPhoneNumber := "+251" + strings.Join(phoneNumberSlice, "")
			phoneNumber = internationalPhoneNumber
			countryCode = "ET"
		}
	}

	parsedPhoneNumber, _ := phonenumbers.Parse(phoneNumber, "")
	validPhoneNumber := phonenumbers.IsValidNumber(parsedPhoneNumber)

	if !isValidFirstName {
		errMap["first_name"] = errors.New("firstname should only contain alpha numerical values and have at least one character")
	}
	if !isValidLastName {
		errMap["last_name"] = errors.New("lastname should only contain alpha numerical values")
	}

	if !validPhoneNumber {
		errMap["phone_number"] = errors.New("invalid phonenumber used")
	} else {
		// If a valid phone number is provided, adjust the phone number to fit the database
		// Stored in +251900010197[ET] or +251900010197 format
		phoneNumber = fmt.Sprintf("+%d%d", parsedPhoneNumber.GetCountryCode(),
			parsedPhoneNumber.GetNationalNumber())

		user.PhoneNumber = phoneNumber
		if countryCode != "" {
			user.PhoneNumber = fmt.Sprintf("%s[%s]", phoneNumber, countryCode)
		}
	}

	if !isValidUserRole {
		errMap["role"] = errors.New("invalid role selected")
	}

	// Meaning a new user is being add
	if user.ID == "" {
		phoneNumberPattern := `^` + tools.EscapeRegexpForDatabase(phoneNumber) + `(\\[[a-zA-Z]{2}])?$`
		if validPhoneNumber && !service.commonRepo.IsUniqueRegx("phone_number", phoneNumberPattern, "users") {
			errMap["phone_number"] = errors.New("phone number already exists")
		}
	} else {
		// Meaning trying to update user
		prevProfile, _ := service.userRepo.Find(user.ID)

		if validPhoneNumber &&
			tools.OnlyPhoneNumber(prevProfile.PhoneNumber) != tools.OnlyPhoneNumber(user.PhoneNumber) {
			phoneNumberPattern := `^` + tools.EscapeRegexpForDatabase(phoneNumber) + `(\\[[a-zA-Z]{2}])?$`
			if !service.commonRepo.IsUniqueRegx("phone_number", phoneNumberPattern, "users") {
				errMap["phone_number"] = errors.New("phone number already exists")
			}
		}
	}

	if len(errMap) > 0 {
		return errMap
	}

	return nil
}

// FindUser is a method that find and return a user that matchs the identifier value
func (service *Service) FindUser(identifier string) (*entity.User, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("no user found")
	}

	user, err := service.userRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("no user found")
	}
	return user, nil
}

// AllUsers is a method that returns all the users in the system
func (service *Service) AllUsers() []*entity.User {
	return service.userRepo.All()
}

// AllUsersWithPagination is a method that returns all the users with pagination
func (service *Service) AllUsersWithPagination(role string, pageNum int64) ([]*entity.User, int64) {

	if !service.ValidUserRole(role) {
		role = entity.UserCategoryAny
	}

	return service.userRepo.FindAll(role, pageNum)
}

// SearchUsers is a method that searchs and returns a set of users related to the key identifier
func (service *Service) SearchUsers(key, role string, pageNum int64, extra ...string) ([]*entity.User, int64) {

	if !service.ValidUserRole(role) {
		role = entity.UserCategoryAny
	}

	defaultSearchColumnsRegx := []string{"first_name"}
	defaultSearchColumnsRegx = append(defaultSearchColumnsRegx, extra...)
	defaultSearchColumns := []string{"id", "phone_number"}

	result1 := make([]*entity.User, 0)
	result2 := make([]*entity.User, 0)
	results := make([]*entity.User, 0)
	resultsMap := make(map[string]*entity.User)
	var pageCount1 int64 = 0
	var pageCount2 int64 = 0
	var pageCount int64 = 0

	empty, _ := regexp.MatchString(`^\s*$`, key)
	if empty {
		return results, 0
	}

	result1, pageCount1 = service.userRepo.Search(key, role, pageNum, defaultSearchColumns...)
	if len(defaultSearchColumnsRegx) > 0 {
		result2, pageCount2 = service.userRepo.SearchWRegx(key, role, pageNum, defaultSearchColumnsRegx...)
	}

	for _, user := range result1 {
		resultsMap[user.ID] = user
	}

	for _, user := range result2 {
		resultsMap[user.ID] = user
	}

	for _, uniqueUser := range resultsMap {
		results = append(results, uniqueUser)
	}

	pageCount = pageCount1
	if pageCount < pageCount2 {
		pageCount = pageCount2
	}

	return results, pageCount
}

// TotalUsers is a method that returns the total number of users for a given user role
func (service *Service) TotalUsers(role string) int64 {

	if !service.ValidUserRole(role) {
		role = entity.UserCategoryAny
	}

	return service.userRepo.Total(role)
}

// FromToUsers is a method that returns the count of users starting from start date to the next 6 months
func (service *Service) FromToUsers(start time.Time) map[string]int64 {

	usersCountMap := make(map[string]int64)

	startTime := start
	for x := 0; x < 6; x++ {
		endTime := start.Add(time.Duration(startTime.Month() + 1))
		usersCountMap[startTime.Month().String()] = service.userRepo.FromTo(startTime, endTime)
		startTime = endTime
	}

	return usersCountMap
}

// UpdateUser is a method that updates a user in the system
func (service *Service) UpdateUser(user *entity.User) error {
	err := service.userRepo.Update(user)
	if err != nil {
		return errors.New("unable to update user")
	}

	return nil
}

// UpdateUserSingleValue is a method that updates a single column entry of a user
func (service *Service) UpdateUserSingleValue(userID, columnName string, columnValue interface{}) error {
	user := entity.User{ID: userID}
	err := service.userRepo.UpdateValue(&user, columnName, columnValue)
	if err != nil {
		return errors.New("unable to update user")
	}

	return nil
}

// DeleteUser is a method that deletes a user from the system
func (service *Service) DeleteUser(userID string) (*entity.User, error) {

	user, err := service.userRepo.Delete(userID)
	if err != nil {
		return nil, errors.New("unable to delete user")
	}

	// Closing all the user's post
	posts := service.postRepo.FindMultiple(userID)
	for _, post := range posts {
		if post.Status == entity.PostStatusOpened {
			service.postRepo.UpdateValue(post, "status", entity.PostStatusClosed)
		}
	}

	// Deleting user's password since passwords table contains
	// both staff and user we have to explicitly delete the user's password
	service.DeletePassword(userID)

	return user, nil
}
