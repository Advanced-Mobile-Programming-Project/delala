package repository

import (
	"errors"
	"fmt"

	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/jinzhu/gorm"
)

// UserRoleRepository is a type that defines a user role repository type
type UserRoleRepository struct {
	conn *gorm.DB
}

// NewUserRoleRepository is a function that creates a new user role repository type
func NewUserRoleRepository(connection *gorm.DB) user.IUserRoleRepository {
	return &UserRoleRepository{conn: connection}
}

// Create is a method that adds a new user role permission to the database
func (repo *UserRoleRepository) Create(newUserRolePermission *entity.UserRolePermission) error {

	totalNumOfMembers := tools.CountMembers("user_role_permissions", repo.conn)
	newUserRolePermission.ID = fmt.Sprintf("UR-ROLE"+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newUserRolePermission.ID, "user_role_permissions", repo.conn) {
		totalNumOfMembers++
		newUserRolePermission.ID = fmt.Sprintf("UR-ROLE"+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)
	}

	err := repo.conn.Create(newUserRolePermission).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain user role permission from the database using an identifier and table name.
// In Find() id is only used as an key
func (repo *UserRoleRepository) Find(identifier string) (*entity.UserRolePermission, error) {
	userRolePermission := new(entity.UserRolePermission)
	err := repo.conn.Model(userRolePermission).
		Where("id = ?", identifier).
		First(userRolePermission).Error

	if err != nil {
		return nil, err
	}
	return userRolePermission, nil
}

// FindMultiple is a method that find multiple role permissions from the database the matches the given identifier
// In FindMultiple() only name is used as a key
// Since one Role is linked to one or more permissions the name of a single role will be assigned with
// multiple permission id so in order to get the permissions of a role we will use this method
func (repo *UserRoleRepository) FindMultiple(identifier string) []*entity.UserRolePermission {

	var userRolePermissions []*entity.UserRolePermission
	err := repo.conn.Model(entity.UserRolePermission{}).Where("name = ?", identifier).Find(&userRolePermissions).Error

	if err != nil {
		return []*entity.UserRolePermission{}
	}
	return userRolePermissions
}

// All is a method that returns all the user role permissions found in the database
func (repo *UserRoleRepository) All() []*entity.UserRolePermission {
	var userRolePermissions []*entity.UserRolePermission
	err := repo.conn.Model(entity.UserRolePermission{}).Find(&userRolePermissions).Error

	if err != nil {
		return []*entity.UserRolePermission{}
	}
	return userRolePermissions
}

// Update is a method that updates a certain user role permission value in the database
func (repo *UserRoleRepository) Update(userRolePermission *entity.UserRolePermission) error {

	prevuserRolePermission := new(entity.UserRolePermission)
	err := repo.conn.Model(prevuserRolePermission).
		Where("id = ?", userRolePermission.ID).First(prevuserRolePermission).Error

	if err != nil {
		return err
	}

	err = repo.conn.Save(userRolePermission).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain user role permission from the database using an identifier.
// In Delete() id is only used as an key
func (repo *UserRoleRepository) Delete(identifier string) (*entity.UserRolePermission, error) {
	userRolePermission := new(entity.UserRolePermission)
	err := repo.conn.Model(userRolePermission).
		Where("id = ?", identifier).First(userRolePermission).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(userRolePermission)
	return userRolePermission, nil
}

// DeleteMultiple is a method that deletes multiple user role permission from the database using an identifier.
// In DeleteMultiple() name is only used as an key
func (repo *UserRoleRepository) DeleteMultiple(identifier string) ([]*entity.UserRolePermission, error) {

	var userRolePermissions []*entity.UserRolePermission
	err := repo.conn.Model(entity.UserRolePermission{}).
		Where("name = ?", identifier).Find(&userRolePermissions).Error

	if err != nil {
		return nil, err
	}

	if len(userRolePermissions) == 0 {
		return nil, errors.New("no user role permission for the provided identifier")
	}

	repo.conn.Model(entity.UserRolePermission{}).Where("name = ?", identifier).Delete(entity.UserRolePermission{})
	return userRolePermissions, nil
}
