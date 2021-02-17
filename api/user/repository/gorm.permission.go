package repository

import (
	"fmt"

	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/jinzhu/gorm"
)

// UserPermissionRepository is a type that defines a user permission repository type
type UserPermissionRepository struct {
	conn *gorm.DB
}

// NewUserPermissionRepository is a function that creates a new user permission repository type
func NewUserPermissionRepository(connection *gorm.DB) user.IUserPermissionRepository {
	return &UserPermissionRepository{conn: connection}
}

// Create is a method that adds a new user permission to the database
func (repo *UserPermissionRepository) Create(newPermission *entity.UserPermission) error {

	totalNumOfMembers := tools.CountMembers("user_permissions", repo.conn)
	newPermission.ID = fmt.Sprintf("UR-PREM"+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newPermission.ID, "user_permissions", repo.conn) {
		totalNumOfMembers++
		newPermission.ID = fmt.Sprintf("UR-PREM"+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)
	}

	err := repo.conn.Create(newPermission).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain user permission from the database using an identifier and table name.
// In Find() id and name are used as an key
func (repo *UserPermissionRepository) Find(identifier string) (*entity.UserPermission, error) {
	permission := new(entity.UserPermission)
	err := repo.conn.Model(permission).
		Where("id = ? || name = ?", identifier, identifier).
		First(permission).Error

	if err != nil {
		return nil, err
	}
	return permission, nil
}

// All is a method that returns all the user permissions of a single user permission table in the database
func (repo *UserPermissionRepository) All() []*entity.UserPermission {
	var permissions []*entity.UserPermission
	err := repo.conn.Model(entity.UserPermission{}).Find(&permissions).Error

	if err != nil {
		return []*entity.UserPermission{}
	}
	return permissions
}

// Update is a method that updates a certain user permission value in the database
func (repo *UserPermissionRepository) Update(permission *entity.UserPermission) error {

	prevPermission := new(entity.UserPermission)
	err := repo.conn.Model(prevPermission).Where("id = ?", permission.ID).First(prevPermission).Error

	if err != nil {
		return err
	}

	err = repo.conn.Save(permission).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain user permission from the database using an identifier.
// In Delete() id and name are used as an key
func (repo *UserPermissionRepository) Delete(identifier string) (*entity.UserPermission, error) {
	permission := new(entity.UserPermission)
	err := repo.conn.Model(permission).Where("id = ? || name = ?", identifier, identifier).First(permission).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(permission)
	return permission, nil
}
