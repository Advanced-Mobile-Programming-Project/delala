package service

import (
	"errors"
	"regexp"

	"github.com/delala/api/entity"
)

// AddUserRole is a method that adds a new user role to the system
// In adding a new role, multiple role permissions will be assigned to a single role
func (service *Service) AddUserRole(newUserRole *entity.UserRole) error {

	createdRolePermissionsID := []string{}
	isCompletelyAdded := true

	for _, newUserRolePermission := range newUserRole.Permissions {
		err := service.roleRepo.Create(newUserRolePermission)
		if err != nil {
			isCompletelyAdded = false
			break
		}

		createdRolePermissionsID = append(createdRolePermissionsID, newUserRolePermission.ID)
	}

	if !isCompletelyAdded {

		// Removing partially created role
		for _, createdRolePermissionID := range createdRolePermissionsID {
			service.roleRepo.Delete(createdRolePermissionID)
		}

		return errors.New("unable to add new user role")
	}

	return nil
}

// ValidateUserRole is a method that checks if the provided user role name is valid or not
func (service *Service) ValidateUserRole(userRole *entity.UserRole) error {

	empty, _ := regexp.MatchString(`^\s*$`, userRole.Name)
	if empty {
		return errors.New("user role name can not be empty")
	}

	for _, userRolePermission := range userRole.Permissions {
		if userRolePermission.Name != userRolePermission.Name {
			return errors.New("user role name and user role permission name not same")
		}
	}

	return nil
}

// ValidUserRole is a method that checks if the provided user role is found the system or not
func (service *Service) ValidUserRole(userRole string) bool {

	isValidUserRole := false
	for _, validUserRole := range service.AllUserRoles() {
		if validUserRole.Name == userRole {
			isValidUserRole = true
		}
	}

	return isValidUserRole
}

// FindUserRole is a method that find and return user role that matches the given identifier
func (service *Service) FindUserRole(identifier string) (*entity.UserRole, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("user role not found")
	}

	userRolePermissions := service.roleRepo.FindMultiple(identifier)
	if len(userRolePermissions) == 0 {
		return nil, errors.New("user role not found")
	}

	userRole := new(entity.UserRole)
	userRole.Name = userRolePermissions[0].Name
	userRole.Permissions = userRolePermissions

	return userRole, nil
}

// FindUserRolePermission is a method that find and return user role permission that matches the given identifier
func (service *Service) FindUserRolePermission(identifier string) (*entity.UserRolePermission, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("user role permission not found")
	}

	userRolePermission, err := service.roleRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("user role permission not found")
	}

	return userRolePermission, nil
}

// AllUserRoles is a method that returns all the user roles found in the system
func (service *Service) AllUserRoles() []*entity.UserRole {

	userRolePermissions := service.roleRepo.All()

	userRoles := make([]*entity.UserRole, 0)
	userRolesMap := make(map[string][]*entity.UserRolePermission)

	for _, userRolePermission := range userRolePermissions {

		if userRolesMap[userRolePermission.Name] == nil {
			userRolesMap[userRolePermission.Name] = []*entity.UserRolePermission{userRolePermission}
		} else {
			userRolesMap[userRolePermission.Name] = append(userRolesMap[userRolePermission.Name], userRolePermission)
		}
	}

	for userRoleName, userRolePermissions := range userRolesMap {
		userRole := new(entity.UserRole)
		userRole.Name = userRoleName
		userRole.Permissions = userRolePermissions

		userRoles = append(userRoles, userRole)
	}

	return userRoles
}

// DeleteUserRole is a method that deletes a user role from the system
func (service *Service) DeleteUserRole(identifier string) (*entity.UserRole, error) {

	userRolePermissions, err := service.roleRepo.DeleteMultiple(identifier)
	if err != nil {
		return nil, errors.New("unable to delete user role")
	}

	userRole := new(entity.UserRole)
	userRole.Name = userRolePermissions[0].Name
	userRole.Permissions = userRolePermissions

	return userRole, nil
}

// DeleteUserRolePermission is a method that deletes a user role permission from the system
func (service *Service) DeleteUserRolePermission(identifier string) (*entity.UserRolePermission, error) {

	userRolePermission, err := service.roleRepo.Delete(identifier)
	if err != nil {
		return nil, errors.New("unable to delete user role permission")
	}

	return userRolePermission, nil
}
