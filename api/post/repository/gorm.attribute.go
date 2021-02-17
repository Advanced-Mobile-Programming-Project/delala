package repository

import (
	"fmt"

	"github.com/delala/api/entity"
	"github.com/delala/api/post"
	"github.com/delala/api/tools"
	"github.com/jinzhu/gorm"
)

// PostAttributeRepository is a type that defines a post attribute repository type
type PostAttributeRepository struct {
	conn *gorm.DB
}

// NewPostAttributeRepository is a function that creates a new post attribute repository type
func NewPostAttributeRepository(connection *gorm.DB) post.IPostAttributeRepository {
	return &PostAttributeRepository{conn: connection}
}

// Create is a method that adds a new post attribute to the database
func (repo *PostAttributeRepository) Create(newAttribute *entity.PostAttribute, tableName string) error {

	var prefix string

	switch tableName {
	case "post_categories":
		prefix = "CATEGORY"
	}

	totalNumOfMembers := tools.CountMembers(tableName, repo.conn)
	newAttribute.ID = fmt.Sprintf(prefix+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newAttribute.ID, tableName, repo.conn) {
		totalNumOfMembers++
		newAttribute.ID = fmt.Sprintf(prefix+"-%s%d", tools.GenerateRandomString(7), totalNumOfMembers+1)
	}

	err := repo.conn.Table(tableName).Create(newAttribute).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain post attribute from the database using an identifier and table name.
// In Find() id and name are used as an key
func (repo *PostAttributeRepository) Find(identifier, tableName string) (*entity.PostAttribute, error) {
	attribute := new(entity.PostAttribute)
	err := repo.conn.Table(tableName).
		Where("id = ? || name = ?", identifier, identifier).
		First(attribute).Error

	if err != nil {
		return nil, err
	}
	return attribute, nil
}

// All is a method that returns all the post attributes of a single post attribute table in the database
func (repo *PostAttributeRepository) All(tableName string) []*entity.PostAttribute {
	var attributes []*entity.PostAttribute
	err := repo.conn.Table(tableName).Find(&attributes).Error

	if err != nil {
		return []*entity.PostAttribute{}
	}
	return attributes
}

// Update is a method that updates a certain post attribute value in the database
func (repo *PostAttributeRepository) Update(attribute *entity.PostAttribute, tableName string) error {

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

// Delete is a method that deletes a certain post attribute from the database using an identifier.
// In Delete() id and name are used as an key
func (repo *PostAttributeRepository) Delete(identifier, tableName string) (*entity.PostAttribute, error) {
	attribute := new(entity.PostAttribute)
	err := repo.conn.Table(tableName).Where("id = ? || name = ?", identifier, identifier).First(attribute).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Table(tableName).Delete(attribute)
	return attribute, nil
}
