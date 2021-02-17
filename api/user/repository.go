package user

import (
	"time"

	"github.com/delala/api/api"
	"github.com/delala/api/entity"
)

// IUserRepository is an interface that defines all the repository methods of a user struct
type IUserRepository interface {
	Create(newUser *entity.User) error
	Find(identifier string) (*entity.User, error)
	FindAll(category string, pageNum int64) ([]*entity.User, int64)
	SearchWRegx(key, category string, pageNum int64, columns ...string) ([]*entity.User, int64)
	Search(key, category string, pageNum int64, columns ...string) ([]*entity.User, int64)
	All() []*entity.User
	Total(category string) int64
	FromTo(start, end time.Time) int64
	Update(user *entity.User) error
	UpdateValue(user *entity.User, columnName string, columnValue interface{}) error
	Delete(identifier string) (*entity.User, error)
}

// IUserRoleRepository is a interface that defines all the repository methods of user role
type IUserRoleRepository interface {
	Create(newUserRolePermission *entity.UserRolePermission) error
	Find(identifier string) (*entity.UserRolePermission, error)
	FindMultiple(identifier string) []*entity.UserRolePermission
	All() []*entity.UserRolePermission
	Update(userRolePermission *entity.UserRolePermission) error
	Delete(identifier string) (*entity.UserRolePermission, error)
	DeleteMultiple(identifier string) ([]*entity.UserRolePermission, error)
}

// IUserPermissionRepository is a interface that defines all the repository methods of user permission
type IUserPermissionRepository interface {
	Create(newPermission *entity.UserPermission) error
	Find(identifier string) (*entity.UserPermission, error)
	All() []*entity.UserPermission
	Update(permission *entity.UserPermission) error
	Delete(identifier string) (*entity.UserPermission, error)
}

// IPasswordRepository is an interface that defines all the repository methods of a user's password struct
type IPasswordRepository interface {
	Create(newOPPassword *entity.Password) error
	Find(identifier string) (*entity.Password, error)
	Update(opPassword *entity.Password) error
	Delete(identifier string) (*entity.Password, error)
}

// IAPIClientRepository is an interface that defines all the repository methods of an api client struct
type IAPIClientRepository interface {
	Create(newAPIClient *api.Client) error
	Find(identifier string) (*api.Client, error)
	Search(identifier string) ([]*api.Client, error)
	SearchMultiple(key string, pageNum int64, columns ...string) []*api.Client
	All(pageNum int64) []*api.Client
	Update(apiClient *api.Client) error
	Delete(identifier string) (*api.Client, error)
	DeleteMultiple(identifier string) ([]*api.Client, error)
}

// IAPITokenRepository is an interface that defines all the repository methods of an api token struct
type IAPITokenRepository interface {
	Create(newAPIToken *api.Token) error
	Find(identifier string) (*api.Token, error)
	Search(identifier string) ([]*api.Token, error)
	SearchMultiple(key string, pageNum int64, columns ...string) []*api.Token
	Update(apiToken *api.Token) error
	Delete(identifier string) (*api.Token, error)
	DeleteMultiple(identifier string) ([]*api.Token, error)
}
