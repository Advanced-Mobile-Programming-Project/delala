package repository

import (
	"github.com/delala/api/common"
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
