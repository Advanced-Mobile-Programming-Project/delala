package common

// ICommonRepository is an interface that defines all the common repository methods
type ICommonRepository interface {
	IsUnique(columnName string, columnValue interface{}, tableName string) bool
	IsUniqueRegx(columnName string, columnPattern string, tableName string) bool
}
