package post

import "github.com/delala/api/entity"

// IPostRepository is an interface that defines all the repository methods of a post struct
type IPostRepository interface {
	Create(newPost *entity.Post) error
	Find(identifier string) (*entity.Post, error)
	FindMultiple(identifier string) []*entity.Post
	FindAll(status string, pageNum int64) ([]*entity.Post, int64)
	SearchWRegx(key, status string, pageNum int64, columns ...string) ([]*entity.Post, int64)
	Search(key, status string, pageNum int64, columns ...string) ([]*entity.Post, int64)
	All() []*entity.Post
	Total(status string) int64
	Update(post *entity.Post) error
	UpdateValue(post *entity.Post, columnName string, columnValue interface{}) error
	Delete(identifier string) (*entity.Post, error)
}

// IPostAttributeRepository is a interface that defines all the repository methods of post attribute
type IPostAttributeRepository interface {
	Create(newAttribute *entity.PostAttribute, tableName string) error
	Find(identifier, tableName string) (*entity.PostAttribute, error)
	All(tableName string) []*entity.PostAttribute
	Update(attribute *entity.PostAttribute, tableName string) error
	Delete(identifier, tableName string) (*entity.PostAttribute, error)
}
