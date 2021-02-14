package user

import (
	"time"

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
