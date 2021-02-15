package common

import "github.com/delala/api/entity"

// IService is an interface that defines all the common service methods
type IService interface {
	AddPostAttribute(newPostAttribute *entity.PostAttribute, tableName string) error
	ValidatePostAttribute(tableName string, jobAttribute *entity.PostAttribute) error
	FindPostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
	AllPostAttributes(tableName string) []*entity.PostAttribute
	UpdatePostAttribute(jobAttribute *entity.PostAttribute, tableName string) error
	DeletePostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
	ValidatePostAttributeTable(tableName string) error

	GetValidPostCategoriesName() []string
	GetValidPostCategories() []*entity.PostAttribute
}
