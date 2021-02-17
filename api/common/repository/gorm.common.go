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

// IsUniqueRegx is a method that determines whether a certain column value pattern is unique in the certain table
func (repo *CommonRepository) IsUniqueRegx(columnName string, columnPattern string, tableName string) bool {
	var totalCount int
	repo.conn.Raw("SELECT COUNT(*) FROM " + tableName + " WHERE " + columnName +
		" REGEXP '" + columnPattern + "'").Count(&totalCount)
	return 0 >= totalCount
}
