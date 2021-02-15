package common

import "github.com/delala/api/entity"

// ICommonRepository is an interface that defines all the common repository methods
type ICommonRepository interface {
	IsUnique(columnName string, columnValue interface{}, tableName string) bool
	CreatePostAttribute(newAttribute *entity.PostAttribute, tableName string) error
	FindPostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
	AllPostAttributes(tableName string) []*entity.PostAttribute
	UpdatePostAttribute(attribute *entity.PostAttribute, tableName string) error
	DeletePostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
}
