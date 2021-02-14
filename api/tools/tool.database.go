package tools

import (
	"github.com/jinzhu/gorm"
)

// CountMembers is a method that counts the number of members in the given table in the database
func CountMembers(tableName string, db *gorm.DB) int {
	var totalNumOfMembers int
	db.Table(tableName).Count(&totalNumOfMembers)
	return totalNumOfMembers
}

// IsUnique is a method that determines whether a certain column value is unique in the given table
func IsUnique(columnName string, columnValue interface{}, tableName string, db *gorm.DB) bool {
	var totalCount int
	db.Table(tableName).Where(columnName+"=?", columnValue).Count(&totalCount)
	return 0 >= totalCount
}
