package repository

import (
	"fmt"

	"github.com/delala/api/common"
	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
	"github.com/jinzhu/gorm"
)

// CommonRepository is a type that defines a repository for common use
type CommonRepository struct {
	conn *gorm.DB
}

// NewCommonRepository is a function that returns a new common repository type
func NewCommonRepository(connection *gorm.DB) common.ICommonRepository {
	return &CommonRepository{conn: connection}
}

// IsUnique is a methods that checks if a given column value is unique in a certain table
func (repo *CommonRepository) IsUnique(columnName string, columnValue interface{}, tableName string) bool {
	return tools.IsUnique(columnName, columnValue, tableName, repo.conn)
}

// ======	======    ======   ======   ======   ======   ======   ======   ======   ======   ======   ======
//    ======	======    ======   ======   ======   ======   ======   ======   ======   ======   ======   ======
// ======	======    ======   ======   ======   ======   ======   ======   ======   ======   ======   ======

// CreatePostAttribute is a method that adds a new post attribute to the database
func (repo *CommonRepository) CreatePostAttribute(newAttribute *entity.PostAttribute, tableName string) error {

	var prefix string

	switch tableName {
	case "post_categories":
		prefix = "CATEGORY"
	}

	totalNumOfMembers := tools.CountMembers(tableName, repo.conn)
	newAttribute.ID = fmt.Sprintf(prefix+"-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newAttribute.ID, tableName, repo.conn) {
		totalNumOfMembers++
		newAttribute.ID = fmt.Sprintf(prefix+"-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)
	}

	err := repo.conn.Table(tableName).Create(newAttribute).Error
	if err != nil {
		return err
	}
	return nil
}

// FindPostAttribute is a method that finds a certain post attribute from the database using an identifier and table name.
// In FindPostAttribute() id and name are used as an key
func (repo *CommonRepository) FindPostAttribute(identifier, tableName string) (*entity.PostAttribute, error) {
	attribute := new(entity.PostAttribute)
	err := repo.conn.Table(tableName).
		Where("id = ? || name = ?", identifier, identifier).
		First(attribute).Error

	if err != nil {
		return nil, err
	}
	return attribute, nil
}

// AllPostAttributes is a method that returns all the post attributes of a single post attribute table in the database
func (repo *CommonRepository) AllPostAttributes(tableName string) []*entity.PostAttribute {
	var attributes []*entity.PostAttribute
	err := repo.conn.Table(tableName).Find(&attributes).Error

	if err != nil {
		return []*entity.PostAttribute{}
	}
	return attributes
}

// UpdatePostAttribute is a method that updates a certain post attribute value in the database
func (repo *CommonRepository) UpdatePostAttribute(attribute *entity.PostAttribute, tableName string) error {

	prevAttribute := new(entity.PostAttribute)
	err := repo.conn.Table(tableName).Where("id = ?", attribute.ID).First(prevAttribute).Error

	if err != nil {
		return err
	}

	err = repo.conn.Table(tableName).Save(attribute).Error
	if err != nil {
		return err
	}
	return nil
}

// DeletePostAttribute is a method that deletes a certain post attribute from the database using an identifier.
// In DeletePostAttribute() id and name are used as an key
func (repo *CommonRepository) DeletePostAttribute(identifier, tableName string) (*entity.PostAttribute, error) {
	attribute := new(entity.PostAttribute)
	err := repo.conn.Table(tableName).Where("id = ? || name = ?", identifier, identifier).First(attribute).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Table(tableName).Delete(attribute)
	return attribute, nil
}
