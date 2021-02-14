package repository

import (
	"fmt"
	"math"
	"regexp"
	"strings"
	"time"

	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/jinzhu/gorm"
)

// UserRepository is a type that defines a user repository type
type UserRepository struct {
	conn *gorm.DB
}

// NewUserRepository is a function that creates a new user repository type
func NewUserRepository(connection *gorm.DB) user.IUserRepository {
	return &UserRepository{conn: connection}
}

// Create is a method that adds a new user to the database
func (repo *UserRepository) Create(newUser *entity.User) error {
	totalNumOfMembers := tools.CountMembers("users", repo.conn)
	newUser.ID = fmt.Sprintf("UR-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newUser.ID, "users", repo.conn) {
		totalNumOfMembers++
		newUser.ID = fmt.Sprintf("UR-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)
	}

	err := repo.conn.Create(newUser).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain user from the database using an identifier,
// also Find() uses id and phone_number as a key for selection
func (repo *UserRepository) Find(identifier string) (*entity.User, error) {

	modifiedIdentifier := identifier
	splitIdentifier := strings.Split(identifier, "")
	if splitIdentifier[0] == "0" {
		modifiedIdentifier = "+251" + strings.Join(splitIdentifier[1:], "")
	}

	user := new(entity.User)
	err := repo.conn.Model(user).
		Where("id = ? || phone_number = ?", identifier, modifiedIdentifier).
		First(user).Error

	if err != nil {
		return nil, err
	}
	return user, nil
}

// FindAll is a method that returns set of users limited to the page number and category
func (repo *UserRepository) FindAll(category string, pageNum int64) ([]*entity.User, int64) {

	var users []*entity.User
	var count float64

	if category == entity.UserCategoryAny {
		repo.conn.Raw("SELECT * FROM users ORDER BY user_name ASC LIMIT ?, 20", pageNum*20).Scan(&users)
		repo.conn.Raw("SELECT COUNT(*) FROM users").Count(&count)

	} else {
		repo.conn.Raw("SELECT * FROM users WHERE category = ? ORDER BY user_name ASC LIMIT ?, 20", category, pageNum*20).Scan(&users)
		repo.conn.Raw("SELECT COUNT(*) FROM users WHERE category = ?", category).Count(&count)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return users, pageCount
}

// SearchWRegx is a method that searchs and returns set of users limited to the key identifier, page number and category using regular expersions
func (repo *UserRepository) SearchWRegx(key, category string, pageNum int64, columns ...string) ([]*entity.User, int64) {
	var users []*entity.User
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s regexp ? ", column))
		sqlValues = append(sqlValues, "^"+regexp.QuoteMeta(key))
	}

	if category == entity.UserCategoryAny {

		repo.conn.Raw("SELECT COUNT(*) FROM users WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM users WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY user_name ASC LIMIT ?, 20",
			sqlValues...).Scan(&users)

	} else {

		sqlValues = append(sqlValues, category)
		repo.conn.Raw("SELECT COUNT(*) FROM users WHERE ("+strings.Join(whereStmt, "||")+") && category = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM users WHERE ("+strings.Join(whereStmt, "||")+") && category = ? ORDER BY user_name ASC LIMIT ?, 20",
			sqlValues...).Scan(&users)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return users, pageCount
}

// Search is a method that searchs and returns set of users limited to the key identifier, page number and category
func (repo *UserRepository) Search(key, category string, pageNum int64, columns ...string) ([]*entity.User, int64) {
	var users []*entity.User
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {

		// modifying the key so that it can match the database phone number values
		if column == "phone_number" {
			splitKey := strings.Split(key, "")
			if splitKey[0] == "0" {
				modifiedKey := "+251" + strings.Join(splitKey[1:], "")
				whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
				sqlValues = append(sqlValues, modifiedKey)
				continue
			}
		}
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	if category == entity.UserCategoryAny {

		repo.conn.Raw("SELECT COUNT(*) FROM users WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM users WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY user_name ASC LIMIT ?, 20", sqlValues...).Scan(&users)

	} else {
		sqlValues = append(sqlValues, category)
		repo.conn.Raw("SELECT COUNT(*) FROM users WHERE ("+strings.Join(whereStmt, "||")+") && category = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM users WHERE ("+strings.Join(whereStmt, "||")+") && category = ? ORDER BY user_name ASC LIMIT ?, 20", sqlValues...).Scan(&users)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return users, pageCount
}

// All is a method that returns all the users found in the database
func (repo *UserRepository) All() []*entity.User {

	var users []*entity.User

	repo.conn.Model(entity.User{}).Find(&users).Order("created_at ASC")

	return users
}

// Total is a method that retruns the total number of users for the given user category
func (repo *UserRepository) Total(category string) int64 {

	var count int64
	if category == entity.UserCategoryAny {
		repo.conn.Raw("SELECT COUNT(*) FROM users").Count(&count)
		return count
	}

	repo.conn.Raw("SELECT COUNT(*) FROM users WHERE category = ?", category).Count(&count)
	return count
}

// FromTo is a method that returns total number of users between start and end time
func (repo *UserRepository) FromTo(start, end time.Time) int64 {

	var count int64
	repo.conn.Raw("SELECT COUNT(*) FROM users WHERE created_at >= ? && created_at <= ?", start, end).Count(&count)
	return count
}

// Update is a method that updates a certain user entries in the database
func (repo *UserRepository) Update(user *entity.User) error {

	prevUser := new(entity.User)
	err := repo.conn.Model(prevUser).Where("id = ?", user.ID).First(prevUser).Error

	if err != nil {
		return err
	}

	/* --------------------------- can change layer if needed --------------------------- */
	user.CreatedAt = prevUser.CreatedAt
	/* -------------------------------------- end --------------------------------------- */

	err = repo.conn.Save(user).Error
	if err != nil {
		return err
	}
	return nil
}

// UpdateValue is a method that updates a certain user single column value in the database
func (repo *UserRepository) UpdateValue(user *entity.User, columnName string, columnValue interface{}) error {

	prevUser := new(entity.User)
	err := repo.conn.Model(prevUser).Where("id = ?", user.ID).First(prevUser).Error

	if err != nil {
		return err
	}

	err = repo.conn.Model(entity.User{}).Where("id = ?", user.ID).
		Update(map[string]interface{}{columnName: columnValue}).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain user from the database using an identifier.
// In Delete() id is only used as an key
func (repo *UserRepository) Delete(identifier string) (*entity.User, error) {
	user := new(entity.User)
	err := repo.conn.Model(user).Where("id = ?", identifier).First(user).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(user)
	return user, nil
}
