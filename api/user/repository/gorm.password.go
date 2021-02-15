package repository

import (
	"github.com/delala/api/entity"
	"github.com/delala/api/user"
	"github.com/jinzhu/gorm"
)

// PasswordRepository is a type that defines a password repository
type PasswordRepository struct {
	conn *gorm.DB
}

// NewPasswordRepository is a function that returns a new password repository
func NewPasswordRepository(connection *gorm.DB) user.IPasswordRepository {
	return &PasswordRepository{conn: connection}
}

// Create is a method that adds a new password to the database
func (repo *PasswordRepository) Create(newPassword *entity.Password) error {

	err := repo.conn.Create(newPassword).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain password from the database using an identifier.
// In Find() id is only used as an key
func (repo *PasswordRepository) Find(identifier string) (*entity.Password, error) {
	memberPassword := new(entity.Password)
	err := repo.conn.Model(memberPassword).
		Where("id = ?", identifier).
		First(memberPassword).Error

	if err != nil {
		return nil, err
	}
	return memberPassword, nil
}

// Update is a method that updates a certain password value in the database
func (repo *PasswordRepository) Update(memberPassword *entity.Password) error {

	prevMemberPassword := new(entity.Password)
	err := repo.conn.Model(prevMemberPassword).Where("id = ?", memberPassword.ID).First(prevMemberPassword).Error

	if err != nil {
		return err
	}

	/* --------------------------- can change layer if needed --------------------------- */

	memberPassword.CreatedAt = prevMemberPassword.CreatedAt

	/* -------------------------------------- end --------------------------------------- */

	err = repo.conn.Save(memberPassword).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain password from the database using an identifier.
// In Delete() id is only used as an key
func (repo *PasswordRepository) Delete(identifier string) (*entity.Password, error) {
	memberPassword := new(entity.Password)
	err := repo.conn.Model(memberPassword).Where("id = ?", identifier).First(memberPassword).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(memberPassword)
	return memberPassword, nil
}
