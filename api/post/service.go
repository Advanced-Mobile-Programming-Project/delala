package post

import "github.com/delala/api/entity"

// IService is an interface that defines all the service methods of a post struct
type IService interface {
	AddPost(newPost *entity.Post) error
	ValidatePost(post *entity.Post) entity.ErrMap
	FindPost(identifier string) (*entity.Post, error)
	FindMultiplePosts(identifier string) []*entity.Post
	AllPosts() []*entity.Post
	AllPostsWithPagination(status string, pageNum int64) ([]*entity.Post, int64)
	SearchPosts(key, status string, pageNum int64, extra ...string) ([]*entity.Post, int64)
	TotalPosts(status string) int64
	UpdatePost(post *entity.Post) error
	UpdatePostSingleValue(postID, columnName string, columnValue interface{}) error
	ApproveOrDecline(postID, status string) (*entity.Post, error)
	DeletePost(postID string) (*entity.Post, error)

	AddPostAttribute(newPostAttribute *entity.PostAttribute, tableName string) error
	ValidatePostAttribute(tableName string, jobAttribute *entity.PostAttribute) error
	FindPostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
	AllPostAttributes(tableName string) []*entity.PostAttribute
	UpdatePostAttribute(jobAttribute *entity.PostAttribute, tableName string) error
	DeletePostAttribute(identifier, tableName string) (*entity.PostAttribute, error)
	ValidatePostAttributeTable(tableName string) error

	GetValidPostCategoriesName() []string
	GetValidPostCategories() []*entity.PostAttribute
}
