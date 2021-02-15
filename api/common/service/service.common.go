package service

import (
	"errors"
	"regexp"
	"strings"

	"github.com/delala/api/common"
	"github.com/delala/api/entity"
)

// Service is a type that defines a common service
type Service struct {
	commonRepo common.ICommonRepository
}

// NewCommonService is a function that returns a new common service
func NewCommonService(commonRepository common.ICommonRepository) common.IService {
	return &Service{commonRepo: commonRepository}
}

// AddPostAttribute is a method that adds a new post attribute to the system
func (service *Service) AddPostAttribute(newPostAttribute *entity.PostAttribute, tableName string) error {

	err := service.commonRepo.CreatePostAttribute(newPostAttribute, tableName)
	if err != nil {
		return errors.New("unable to add new post attribute")
	}

	return nil
}

// ValidatePostAttribute is a method that checks if the provided table and attribtue name is valid or not
func (service *Service) ValidatePostAttribute(tableName string, postAttribute *entity.PostAttribute) error {

	if err := service.ValidatePostAttributeTable(tableName); err != nil {
		return err
	}

	empty, _ := regexp.MatchString(`^\s*$`, postAttribute.Name)
	if empty {
		return errors.New("post attribute name can not be empty")
	}

	postAttribute.Name = strings.TrimSpace(postAttribute.Name)

	prevPostAttribute, _ := service.commonRepo.FindPostAttribute(postAttribute.Name, tableName)
	if prevPostAttribute != nil {
		return errors.New("post attribute already exist")
	}

	return nil
}

// FindPostAttribute is a method that find and return post attribute that matches the given identifier
func (service *Service) FindPostAttribute(identifier, tableName string) (*entity.PostAttribute, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("post attribute not found")
	}

	if err := service.ValidatePostAttributeTable(tableName); err != nil {
		return nil, err
	}

	postAttribute, err := service.commonRepo.FindPostAttribute(identifier, tableName)
	if err != nil {
		return nil, errors.New("post attribute not found")
	}

	return postAttribute, nil
}

// AllPostAttributes is a method that returns all the post attributes a given table
func (service *Service) AllPostAttributes(tableName string) []*entity.PostAttribute {

	if err := service.ValidatePostAttributeTable(tableName); err != nil {
		return []*entity.PostAttribute{}
	}

	return service.commonRepo.AllPostAttributes(tableName)
}

// UpdatePostAttribute is a method that updates a post attribute in the system
func (service *Service) UpdatePostAttribute(postAttribute *entity.PostAttribute, tableName string) error {

	if err := service.ValidatePostAttributeTable(tableName); err != nil {
		return err
	}

	err := service.commonRepo.UpdatePostAttribute(postAttribute, tableName)
	if err != nil {
		return errors.New("unable to update post attribute")
	}

	return nil
}

// DeletePostAttribute is a method that deletes a post attribute from the system
func (service *Service) DeletePostAttribute(identifier, tableName string) (*entity.PostAttribute, error) {

	if err := service.ValidatePostAttributeTable(tableName); err != nil {
		return nil, err
	}

	postAttribute, err := service.commonRepo.DeletePostAttribute(identifier, tableName)
	if err != nil {
		return nil, errors.New("unable to delete post attribute")
	}

	return postAttribute, nil
}

// ValidatePostAttributeTable is a method that checks if the provided table name is valid or not
func (service *Service) ValidatePostAttributeTable(tableName string) error {

	switch tableName {
	case "post_categories":
		return nil
	}

	return errors.New("table does not exist")
}

// GetValidPostCategoriesName is a method that gets the valid post categories name allowed by the system
func (service *Service) GetValidPostCategoriesName() []string {

	postTypes := service.AllPostAttributes("post_categories")
	validPostCategories := make([]string, 0)

	for _, postType := range postTypes {
		validPostCategories = append(validPostCategories, postType.Name)
	}

	if len(validPostCategories) > 0 {
		validPostCategories = append(validPostCategories, "Other")
	}

	return validPostCategories
}

// GetValidPostCategories is a method that gets the valid post categories allowed by the system
func (service *Service) GetValidPostCategories() []*entity.PostAttribute {

	postTypes := service.AllPostAttributes("post_categories")

	if len(postTypes) > 0 {
		postType := new(entity.PostAttribute)
		postType.Name = "Other"
		postTypes = append(postTypes, postType)
	}

	return postTypes
}
