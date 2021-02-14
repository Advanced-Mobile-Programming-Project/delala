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
	"github.com/delala/api/user"
	"github.com/nyaruka/phonenumbers"
)

// Service is a type that defines a user service
type Service struct {
	userRepo   user.IUserRepository
	postRepo   post.IPostRepository
	commonRepo common.ICommonRepository
}

// NewUserService is a function that returns a new user service
func NewUserService(userRepository user.IUserRepository, postRepository post.IPostRepository,
	commonRepository common.ICommonRepository) user.IService {
	return &Service{userRepo: userRepository,
		postRepo: postRepository, commonRepo: commonRepository}
}

// AddUser is a method that adds a new user to the system
func (service *Service) AddUser(newUser *entity.User) error {
	err := service.userRepo.Create(newUser)
	if err != nil {
		return errors.New("unable to add new user")
	}

	return nil
}

// ValidateUserProfile is a method that validates a user profile.
// It checks if the user has a valid entries or not and return map of errors if any.
// Also it will add country code to the phone number value if not included: default country code +251
func (service *Service) ValidateUserProfile(user *entity.User) entity.ErrMap {

	errMap := make(map[string]error)
	validUserName, _ := regexp.MatchString(`^\w[\w\s]*$`, user.UserName)

	var phoneNumber string
	phoneNumber = user.PhoneNumber

	// Checking for local phone number
	isLocalPhoneNumber, _ := regexp.MatchString(`^0\d{9}$`, phoneNumber)

	if isLocalPhoneNumber {
		phoneNumberSlice := strings.Split(phoneNumber, "")
		if phoneNumberSlice[0] == "0" {
			phoneNumberSlice = phoneNumberSlice[1:]
			internationalPhoneNumber := "+251" + strings.Join(phoneNumberSlice, "")
			phoneNumber = internationalPhoneNumber
		}
	}

	parsedPhoneNumber, _ := phonenumbers.Parse(phoneNumber, "")
	validPhoneNumber := phonenumbers.IsValidNumber(parsedPhoneNumber)

	if !validUserName {
		errMap["user_name"] = errors.New(`user name should have at least one character and ` +
			`contain only alpha numeric value`)
	} else if len(user.UserName) > 255 {
		errMap["user_name"] = errors.New(`user name should not be longer than 255 characters`)
	}

	if !validPhoneNumber {
		errMap["phone_number"] = errors.New("invalid phonenumber used")
	} else {
		// If a valid phone number is provided, adjust the phone number to fit the database
		// Stored in +251900010197 format
		phoneNumber = fmt.Sprintf("+%d%d", parsedPhoneNumber.GetCountryCode(),
			parsedPhoneNumber.GetNationalNumber())

		user.PhoneNumber = phoneNumber
	}

	// if user.Category != entity.UserCategoryAseri &&
	// 	user.Category != entity.UserCategoryAgent &&
	// 	user.Category != entity.UserCategoryJobSeeker {
	// 	errMap["category"] = errors.New("invalid category selected")
	// }

	// Meaning a new user is being add
	if user.ID == "" {
		if validPhoneNumber && !service.commonRepo.IsUnique("phone_number", user.PhoneNumber, "users") {
			errMap["phone_number"] = errors.New("phone number already exists")
		}
	} else {
		// Meaning trying to update user
		prevProfile, err := service.userRepo.Find(user.ID)

		// Checking for err isn't relevant but to make it robust check for nil pointer
		if err == nil && validPhoneNumber && prevProfile.PhoneNumber != user.PhoneNumber {
			if !service.commonRepo.IsUnique("phone_number", user.PhoneNumber, "users") {
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
func (service *Service) AllUsersWithPagination(category string, pageNum int64) ([]*entity.User, int64) {

	// if category != entity.UserCategoryAseri && category != entity.UserCategoryAgent &&
	// 	category != entity.UserCategoryJobSeeker {
	// 	category = entity.UserCategoryAny
	// }

	return service.userRepo.FindAll(category, pageNum)
}

// SearchUsers is a method that searchs and returns a set of users related to the key identifier
func (service *Service) SearchUsers(key, category string, pageNum int64, extra ...string) ([]*entity.User, int64) {

	// if category != entity.UserCategoryAseri && category != entity.UserCategoryAgent &&
	// 	category != entity.UserCategoryJobSeeker {
	// 	category = entity.UserCategoryAny
	// }

	defaultSearchColumnsRegx := []string{"user_name"}
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

	result1, pageCount1 = service.userRepo.Search(key, category, pageNum, defaultSearchColumns...)
	if len(defaultSearchColumnsRegx) > 0 {
		result2, pageCount2 = service.userRepo.SearchWRegx(key, category, pageNum, defaultSearchColumnsRegx...)
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

// TotalUsers is a method that returns the total number of users for a given user category
func (service *Service) TotalUsers(category string) int64 {

	// if category != entity.UserCategoryAgent && category != entity.UserCategoryAseri &&
	// 	category != entity.UserCategoryJobSeeker {
	// 	category = entity.UserCategoryAny
	// }

	return service.userRepo.Total(category)
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

	// Closing opened jobs of a user
	// jobs := service.postRepo.FindMultiple(userID)
	// for _, job := range jobs {
	// if job.Status == entity.JobStatusOpened {
	// 	service.postRepo.UpdateValue(job, "status", entity.JobStatusClosed)
	// }
	// }

	user, err := service.userRepo.Delete(userID)
	if err != nil {
		return nil, errors.New("unable to delete user")
	}

	return user, nil
}
