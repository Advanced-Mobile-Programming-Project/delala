package repository

import (
	"fmt"
	"math"
	"regexp"
	"strings"

	"github.com/delala/api/entity"
	"github.com/delala/api/post"
	"github.com/delala/api/tools"
	"github.com/jinzhu/gorm"
)

// PostRepository is a type that defines a post repository type
type PostRepository struct {
	conn *gorm.DB
}

// NewPostRepository is a function that creates a new post repository type
func NewPostRepository(connection *gorm.DB) post.IPostRepository {
	return &PostRepository{conn: connection}
}

// Create is a method that adds a new post to the database
func (repo *PostRepository) Create(newPost *entity.Post) error {
	totalNumOfMembers := tools.CountMembers("posts", repo.conn)
	newPost.ID = fmt.Sprintf("PT-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)

	for !tools.IsUnique("id", newPost.ID, "posts", repo.conn) {
		totalNumOfMembers++
		newPost.ID = fmt.Sprintf("PT-%s%d", tools.RandomStringGN(7), totalNumOfMembers+1)
	}

	err := repo.conn.Create(newPost).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain post from the database using an identifier,
// also Find() uses only id as a key for selection
func (repo *PostRepository) Find(identifier string) (*entity.Post, error) {

	post := new(entity.Post)
	err := repo.conn.Model(post).Where("id = ?", identifier).First(post).Error

	if err != nil {
		return nil, err
	}
	return post, nil
}

// FindMultiple is a method that find multiple posts from the database the matches the given identifier
// In FindMultiple() only user_id is used as a key
func (repo *PostRepository) FindMultiple(identifier string) []*entity.Post {

	var posts []*entity.Post
	err := repo.conn.Model(entity.Post{}).Where("user_id = ?", identifier).Find(&posts).Error

	if err != nil {
		return []*entity.Post{}
	}
	return posts
}

// FindAll is a method that returns set of posts limited to the page number and status
func (repo *PostRepository) FindAll(status string, pageNum int64) ([]*entity.Post, int64) {
	var posts []*entity.Post
	var count float64

	switch status {
	case entity.PostStatusPending:
		fallthrough
	case entity.PostStatusOpened:
		fallthrough
	case entity.PostStatusClosed:
		fallthrough
	case entity.PostStatusDecelined:
		repo.conn.Raw("SELECT * FROM posts WHERE status = ? ORDER BY created_at DESC LIMIT ?, 40", status, pageNum*40).Scan(&posts)
		repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE status = ?", status).Count(&count)
		break
	case entity.PostStatusAny:
		fallthrough
	default:
		repo.conn.Raw("SELECT * FROM posts ORDER BY created_at DESC LIMIT ?, 40", pageNum*40).Scan(&posts)
		repo.conn.Raw("SELECT COUNT(*) FROM posts").Count(&count)
	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return posts, pageCount
}

// SearchWRegx is a method that searchs and returns set of posts limited to the key identifier and page number using regular expersions
func (repo *PostRepository) SearchWRegx(key, status string, pageNum int64, columns ...string) ([]*entity.Post, int64) {
	var posts []*entity.Post
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s regexp ? ", column))
		sqlValues = append(sqlValues, "^"+regexp.QuoteMeta(key))
	}

	switch status {
	case entity.PostStatusPending:
		fallthrough
	case entity.PostStatusOpened:
		fallthrough
	case entity.PostStatusClosed:
		fallthrough
	case entity.PostStatusDecelined:

		sqlValues = append(sqlValues, status)
		repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE ("+strings.Join(whereStmt, "||")+") && status = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM posts WHERE "+strings.Join(whereStmt, "||")+" && status = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&posts)

	case entity.PostStatusAny:
		fallthrough
	default:

		repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM posts WHERE "+strings.Join(whereStmt, "||")+" ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&posts)

	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return posts, pageCount
}

// Search is a method that searchs and returns set of posts limited to the key identifier and page number
func (repo *PostRepository) Search(key, status string, pageNum int64, columns ...string) ([]*entity.Post, int64) {
	var posts []*entity.Post
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	switch status {
	case entity.PostStatusPending:
		fallthrough
	case entity.PostStatusOpened:
		fallthrough
	case entity.PostStatusClosed:
		fallthrough
	case entity.PostStatusDecelined:

		sqlValues = append(sqlValues, status)
		repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE ("+strings.Join(whereStmt, "||")+") && status = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM posts WHERE "+strings.Join(whereStmt, "||")+" && status = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&posts)

	case entity.PostStatusAny:
		fallthrough
	default:

		repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM posts WHERE "+strings.Join(whereStmt, "||")+" ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&posts)

	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return posts, pageCount
}

// All is a method that returns all the posts found in the database
func (repo *PostRepository) All() []*entity.Post {

	var posts []*entity.Post

	repo.conn.Model(entity.Post{}).Find(&posts).Order("created_at ASC")

	return posts
}

// Total is a method that retruns the total number of posts for the given status type
func (repo *PostRepository) Total(status string) int64 {

	var count int64
	if status == entity.PostStatusAny {
		repo.conn.Raw("SELECT COUNT(*) FROM posts").Count(&count)
		return count
	}

	repo.conn.Raw("SELECT COUNT(*) FROM posts WHERE status = ?", status).Count(&count)
	return count
}

// Update is a method that updates a certain post entries in the database
func (repo *PostRepository) Update(post *entity.Post) error {

	prevPost := new(entity.Post)
	err := repo.conn.Model(prevPost).Where("id = ?", post.ID).First(prevPost).Error

	if err != nil {
		return err
	}

	/* --------------------------- can change layer if needed --------------------------- */
	post.CreatedAt = prevPost.CreatedAt
	/* -------------------------------------- end --------------------------------------- */

	err = repo.conn.Save(post).Error
	if err != nil {
		return err
	}
	return nil
}

// UpdateValue is a method that updates a certain post single column value in the database
func (repo *PostRepository) UpdateValue(post *entity.Post, columnName string, columnValue interface{}) error {

	prevPost := new(entity.Post)
	err := repo.conn.Model(prevPost).Where("id = ?", post.ID).First(prevPost).Error

	if err != nil {
		return err
	}

	err = repo.conn.Model(entity.Post{}).Where("id = ?", post.ID).
		Update(map[string]interface{}{columnName: columnValue}).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain post from the database using an identifier.
// In Delete() id is only used as an key
func (repo *PostRepository) Delete(identifier string) (*entity.Post, error) {
	post := new(entity.Post)
	err := repo.conn.Model(post).Where("id = ?", identifier).First(post).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(post)
	return post, nil
}
