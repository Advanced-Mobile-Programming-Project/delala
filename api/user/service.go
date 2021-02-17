package user

import "github.com/delala/api/entity"

// IService is an interface that defines all the service methods of a user struct
type IService interface {
	AddUser(newUser *entity.User, newPassword *entity.Password) error
	ValidateUserProfile(user *entity.User) entity.ErrMap
	FindUser(identifier string) (*entity.User, error)
	AllUsers() []*entity.User
	AllUsersWithPagination(category string, pageNum int64) ([]*entity.User, int64)
	SearchUsers(key, category string, pageNum int64, extra ...string) ([]*entity.User, int64)
	TotalUsers(category string) int64
	UpdateUser(user *entity.User) error
	UpdateUserSingleValue(userID, columnName string, columnValue interface{}) error
	DeleteUser(userID string) (*entity.User, error)

	AddUserRole(newUserRole *entity.UserRole) error
	ValidateUserRole(userRole *entity.UserRole) error
	FindUserRole(identifier string) (*entity.UserRole, error)
	FindUserRolePermission(identifier string) (*entity.UserRolePermission, error)
	AllUserRoles() []*entity.UserRole
	DeleteUserRole(identifier string) (*entity.UserRole, error)
	DeleteUserRolePermission(identifier string) (*entity.UserRolePermission, error)
}
