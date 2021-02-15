package service

import (
	"encoding/base64"
	"errors"
	"regexp"

	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
	"golang.org/x/crypto/bcrypt"
)

// FindPassword is a method that find and return a user's password that matchs the identifier value
func (service *Service) FindPassword(identifier string) (*entity.Password, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("password not found")
	}

	memberPassword, err := service.passwordRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("password not found")
	}
	return memberPassword, nil
}

// VerifyPassword is a method that verify a user has provided a valid password with a matching verifypassword entry
func (service *Service) VerifyPassword(memberPassword *entity.Password, verifyPassword string) error {
	matchPassword, _ := regexp.MatchString(`^[a-zA-Z0-9\._\-&!?=#]{8}[a-zA-Z0-9\._\-&!?=#]*$`, memberPassword.Password)

	if len(memberPassword.Password) < 8 {
		return errors.New("password should contain at least 8 characters")
	}

	if !matchPassword {
		return errors.New("invalid characters used in password")
	}

	if memberPassword.Password != verifyPassword {
		return errors.New("password does not match")
	}

	memberPassword.Salt = tools.RandomStringGN(30)
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(memberPassword.Password+memberPassword.Salt), 12)
	memberPassword.Password = base64.StdEncoding.EncodeToString(hashedPassword)

	return nil
}

// UpdatePassword is a method that updates a certain user password
func (service *Service) UpdatePassword(memberPassword *entity.Password) error {
	err := service.passwordRepo.Update(memberPassword)
	if err != nil {
		return errors.New("unable to update password")
	}
	return nil
}

// DeletePassword is a method that deletes a certain user password
func (service *Service) DeletePassword(identifier string) (*entity.Password, error) {
	password, err := service.passwordRepo.Delete(identifier)
	if err != nil {
		return nil, errors.New("unable to delete password")
	}

	return password, nil
}
