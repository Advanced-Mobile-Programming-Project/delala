package user

import (
	"github.com/delala/api/api"
	"github.com/delala/api/entity"
)

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

	VerifyPassword(memberPassword *entity.Password, verifyPassword string) error
	FindPassword(identifier string) (*entity.Password, error)
	UpdatePassword(memberPassword *entity.Password) error
	DeletePassword(identifier string) (*entity.Password, error)

	AddAPIClient(apiClient *api.Client, opUser *entity.User) error
	FindAPIClient(identifier string) (*api.Client, error)
	SearchAPIClient(identifier, clientType string) ([]*api.Client, error)
	SearchMultipleAPIClient(key, pagination string, columns ...string) []*api.Client
	AllAPIClients(pagination string) []*api.Client
	UpdateAPIClient(apiClient *api.Client) error
	DeleteAPIClient(identifier string) (*api.Client, error)
	DeleteAPIClients(identifier string) ([]*api.Client, error)

	AddAPIToken(apiToken *api.Token, apiClient *api.Client, opUser *entity.User) error
	FindAPIToken(identifier string) (*api.Token, error)
	SearchAPIToken(identifier string) ([]*api.Token, error)
	SearchMultipleAPIToken(key, pagination string, columns ...string) []*api.Token
	ValidateAPIToken(apiToken *api.Token) error
	UpdateAPIToken(apiToken *api.Token) error
	DeleteAPIToken(identifier string) (*api.Token, error)
	DeleteAPITokens(identifier string) ([]*api.Token, error)
}
