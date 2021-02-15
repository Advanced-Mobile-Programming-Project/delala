package service

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/delala/api/common"
	"github.com/delala/api/entity"
	"github.com/delala/api/staff"
	"github.com/delala/api/tools"
)

// Service is a type that defines staff service
type Service struct {
	staffRepo    staff.IStaffRepository
	passwordRepo staff.IPasswordRepository
	commonRepo   common.ICommonRepository
	sessionRepo  staff.ISessionRepository
}

// NewStaffService is a function that returns a new staff service
func NewStaffService(staffRepository staff.IStaffRepository,
	passwordRepository staff.IPasswordRepository, sessionRepository staff.ISessionRepository,
	commonRepository common.ICommonRepository) staff.IService {
	return &Service{staffRepo: staffRepository, passwordRepo: passwordRepository,
		commonRepo: commonRepository, sessionRepo: sessionRepository}
}

// AddStaffMember is a method that adds a new staff member to the system along with the password
func (service *Service) AddStaffMember(newStaffMember *entity.Staff, newPassword *entity.Password) error {

	err := service.staffRepo.Create(newStaffMember)
	if err != nil {
		return errors.New("unable to add new staff member")
	}
	newPassword.ID = newStaffMember.ID
	err = service.passwordRepo.Create(newPassword)
	if err != nil {
		// Cleaning up if password is not add to the database
		service.staffRepo.Delete(newStaffMember.ID)
		return errors.New("unable to add new staff member")
	}

	return nil
}

// ValidateStaffMemberProfile is a method that validate a staff member profile.
// It checks if the staff member has a valid entries or not and return map of errors if any.
// Also it will add country code to the phone number value if not included: default country code +251
func (service *Service) ValidateStaffMemberProfile(staffMember *entity.Staff) entity.ErrMap {

	errMap := tools.ValidateProfile(entity.RoleStaff, staffMember.FirstName, staffMember.LastName,
		staffMember.PhoneNumber, staffMember.Email)
	if errMap == nil {
		errMap = make(entity.ErrMap)
	}

	if errMap["phone_number"] == nil {

		// If a valid phone number is provided, adjust the phone number to fit the database
		phoneNumberSlice := strings.Split(staffMember.PhoneNumber, "")
		if phoneNumberSlice[0] == "0" {
			phoneNumberSlice = phoneNumberSlice[1:]
			validPhoneNumber := "+251" + strings.Join(phoneNumberSlice, "")
			staffMember.PhoneNumber = validPhoneNumber
		}

	}

	// Meaning a new user is being add
	if staffMember.ID == "" {

		if errMap["email"] == nil && !service.commonRepo.IsUnique("email", staffMember.Email, "staffs") {
			errMap["email"] = errors.New("email address already exists")
		}

		if errMap["phone_number"] == nil && !service.commonRepo.IsUnique("phone_number", staffMember.PhoneNumber, "staffs") {
			errMap["phone_number"] = errors.New("phonenumber already exists")
		}

	} else {
		// Meaning trying to update user
		prevProfile, _ := service.staffRepo.Find(staffMember.ID)

		// checking uniqueness only for email that isn't identical to the user's previous email
		if errMap["email"] == nil && prevProfile.Email != staffMember.Email {
			if !service.commonRepo.IsUnique("email", staffMember.Email, "staffs") {
				errMap["email"] = errors.New("email address already exists")
			}
		}

		if errMap["phone_number"] == nil && prevProfile.PhoneNumber != staffMember.PhoneNumber {
			if !service.commonRepo.IsUnique("phone_number", staffMember.PhoneNumber, "staffs") {
				errMap["phone_number"] = errors.New("phonenumber already exists")
			}
		}
	}

	if len(errMap) > 0 {
		return errMap
	}

	return nil
}

// UpdateStaffMember is a method that updates a staff member in the system
func (service *Service) UpdateStaffMember(staffMember *entity.Staff) error {
	err := service.staffRepo.Update(staffMember)
	if err != nil {
		return errors.New("unable to update staff member")
	}
	return nil
}

// UpdateStaffMemberSingleValue is a method that updates a single column entry of a staff member
func (service *Service) UpdateStaffMemberSingleValue(staffMemberID, columnName, columnValue string) error {
	staffMember := entity.Staff{ID: staffMemberID}
	err := service.staffRepo.UpdateValue(&staffMember, columnName, columnValue)
	if err != nil {
		return errors.New("unable to update staff member")
	}
	return nil
}

// FindStaffMember is a method that find and return a staff member that matchs the identifier value
func (service *Service) FindStaffMember(identifier string) (*entity.Staff, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("empty identifier used")
	}

	staffMember, err := service.staffRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("staff member not found")
	}
	return staffMember, nil
}

// AllStaffMembers is a method that returns all the staff members with pagination
func (service *Service) AllStaffMembers(role string, pageNum int64) ([]*entity.Staff, int64) {

	if role != entity.RoleAdmin && role != entity.RoleStaff {
		role = entity.RoleAny
	}
	return service.staffRepo.FindAll(role, pageNum)
}

// SearchStaffMembers is a method that searchs and returns a set of staff members related to the key identifier
func (service *Service) SearchStaffMembers(key, role string, pageNum int64, extra ...string) ([]*entity.Staff, int64) {

	if role != entity.RoleAdmin && role != entity.RoleStaff {
		role = entity.RoleAny
	}

	defaultSearchColumnsRegx := []string{"first_name", "email"}
	defaultSearchColumnsRegx = append(defaultSearchColumnsRegx, extra...)
	defaultSearchColumns := []string{"id", "phone_number"}

	result1 := make([]*entity.Staff, 0)
	result2 := make([]*entity.Staff, 0)
	results := make([]*entity.Staff, 0)
	resultsMap := make(map[string]*entity.Staff)
	var pageCount1 int64 = 0
	var pageCount2 int64 = 0
	var pageCount int64 = 0

	empty, _ := regexp.MatchString(`^\s*$`, key)
	if empty {
		return results, 0
	}

	result1, pageCount1 = service.staffRepo.Search(key, role, pageNum, defaultSearchColumns...)
	if len(defaultSearchColumnsRegx) > 0 {
		result2, pageCount2 = service.staffRepo.SearchWRegx(key, role, pageNum, defaultSearchColumnsRegx...)
	}

	for _, staffMember := range result1 {
		resultsMap[staffMember.ID] = staffMember
	}

	for _, staffMember := range result2 {
		resultsMap[staffMember.ID] = staffMember
	}

	for _, uniqueStaffMember := range resultsMap {
		results = append(results, uniqueStaffMember)
	}

	pageCount = pageCount1
	if pageCount < pageCount2 {
		pageCount = pageCount2
	}

	return results, pageCount
}

// DeleteStaffMember is a method that deletes a staff member from the system including it's session's and password
func (service *Service) DeleteStaffMember(staffMemberID string) (*entity.Staff, error) {

	staffMember, err := service.staffRepo.Delete(staffMemberID)
	if err != nil {
		return nil, errors.New("unable to delete staff member")
	}

	service.passwordRepo.Delete(staffMemberID)
	service.sessionRepo.DeleteMultiple(staffMemberID)

	if staffMember.ProfilePic != "" {
		wd, _ := os.Getwd()
		// The pervious was "./assets/profilepics"
		filePath := filepath.Join(wd, "../../assets/profilepics", staffMember.ProfilePic)
		fmt.Println(filePath)
		tools.RemoveFile(filePath)
	}

	return staffMember, nil
}
