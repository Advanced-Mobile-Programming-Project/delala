package service

import (
	"errors"
	"regexp"
	"strings"

	"github.com/delala/api/entity"
	"github.com/delala/api/post"
	"github.com/delala/api/user"
)

// Service is a type that defines a post service
type Service struct {
	postRepo post.IPostRepository
	attrRepo post.IPostAttributeRepository
}

// NewPostService is a function that returns a new post service
func NewPostService(postRepository post.IPostRepository, userRepository user.IUserRepository,
	postAttributeRepository post.IPostAttributeRepository) post.IService {
	return &Service{postRepo: postRepository, attrRepo: postAttributeRepository}
}

// AddPost is a method that adds a new post to the system
func (service *Service) AddPost(newPost *entity.Post) error {

	// Initiating new post
	if newPost.Status == "" {
		newPost.Status = entity.PostStatusPending
	}

	err := service.postRepo.Create(newPost)
	if err != nil {
		return errors.New("unable to add new post")
	}

	return nil
}

// ValidatePost is a method that validates a post entries.
// It checks if the post has a valid entries or not and return map of errors if any.
func (service *Service) ValidatePost(post *entity.Post) entity.ErrMap {

	errMap := make(map[string]error)
	var isValidPostCategory bool
	validPostCategories := service.GetValidPostCategoriesName()

	emptyTitle, _ := regexp.MatchString(`^\s*$`, post.Title)
	if emptyTitle {
		errMap["title"] = errors.New("post title can not be empty")
	} else if len(post.Title) > 300 {
		errMap["title"] = errors.New("post title can not exceed 300 characters")
	}

	emptyDescription, _ := regexp.MatchString(`^\s*$`, post.Description)
	if emptyDescription {
		errMap["description"] = errors.New("post description can not be empty")
	} else if len(post.Title) > 2000 {
		errMap["description"] = errors.New("post description can not exceed 2000 characters")
	}

	for _, validPostCategory := range validPostCategories {
		if strings.ToLower(strings.TrimSpace(post.Category)) == strings.ToLower(validPostCategory) {
			isValidPostCategory = true
			break
		}
	}

	// if post.UserID != "" {
	// 	user, err := service.userRepo.Find(post.UserID)
	// 	if err != nil {
	// 		errMap["user_id"] = errors.New("no user found for the provided user id")
	// 	} else if user.Category != entity.UserCategoryDelala {
	// 		errMap["user_id"] = errors.New("can not perform operation for non delala user")
	// 	}
	// } else {
	// 	errMap["user_id"] = errors.New("no user found for the provided user id")
	// }

	if !isValidPostCategory {
		errMap["category"] = errors.New("invalid post category used")
	}

	if len(errMap) > 0 {
		return errMap
	}

	return nil
}

// FindPost is a method that find and return a post that matchs the identifier value
func (service *Service) FindPost(identifier string) (*entity.Post, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("no post found")
	}

	post, err := service.postRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("no post found")
	}
	return post, nil
}

// FindMultiplePosts is a method that find and return multiple posts that matchs the identifier value
func (service *Service) FindMultiplePosts(identifier string) []*entity.Post {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return []*entity.Post{}
	}

	return service.postRepo.FindMultiple(identifier)
}

// AllPosts is a method that returns all the posts in the system
func (service *Service) AllPosts() []*entity.Post {
	return service.postRepo.All()
}

// AllPostsWithPagination is a method that returns all the posts with pagination
func (service *Service) AllPostsWithPagination(status string, pageNum int64) ([]*entity.Post, int64) {

	if status != entity.PostStatusPending && status != entity.PostStatusOpened &&
		status != entity.PostStatusClosed && status != entity.PostStatusDecelined {
		status = entity.PostStatusAny
	}

	return service.postRepo.FindAll(status, pageNum)
}

// TotalPosts is a method that returns the total number of posts for a given post status
func (service *Service) TotalPosts(status string) int64 {

	if status != entity.PostStatusClosed && status != entity.PostStatusOpened &&
		status != entity.PostStatusPending && status != entity.PostStatusDecelined {
		status = entity.PostStatusAny
	}

	return service.postRepo.Total(status)
}

// SearchPosts is a method that searchs and returns a set of posts related to the key identifier
func (service *Service) SearchPosts(key, status string, pageNum int64, extra ...string) ([]*entity.Post, int64) {

	if status != entity.PostStatusPending && status != entity.PostStatusOpened &&
		status != entity.PostStatusClosed && status != entity.PostStatusDecelined {
		status = entity.PostStatusAny
	}

	defaultSearchColumnsRegx := []string{"title"}
	defaultSearchColumnsRegx = append(defaultSearchColumnsRegx, extra...)
	defaultSearchColumns := []string{"id", "user_id", "category"}

	result1 := make([]*entity.Post, 0)
	result2 := make([]*entity.Post, 0)
	results := make([]*entity.Post, 0)
	resultsMap := make(map[string]*entity.Post)
	var pageCount1 int64 = 0
	var pageCount2 int64 = 0
	var pageCount int64 = 0

	empty, _ := regexp.MatchString(`^\s*$`, key)
	if empty {
		return results, 0
	}

	result1, pageCount1 = service.postRepo.Search(key, status, pageNum, defaultSearchColumns...)
	if len(defaultSearchColumnsRegx) > 0 {
		result2, pageCount2 = service.postRepo.SearchWRegx(key, status, pageNum, defaultSearchColumnsRegx...)
	}

	for _, post := range result1 {
		resultsMap[post.ID] = post
	}

	for _, post := range result2 {
		resultsMap[post.ID] = post
	}

	for _, uniquePost := range resultsMap {
		results = append(results, uniquePost)
	}

	pageCount = pageCount1
	if pageCount < pageCount2 {
		pageCount = pageCount2
	}

	return results, pageCount
}

// UpdatePost is a method that updates a post in the system
func (service *Service) UpdatePost(post *entity.Post) error {
	err := service.postRepo.Update(post)
	if err != nil {
		return errors.New("unable to update post")
	}

	return nil
}

// UpdatePostSingleValue is a method that updates a single column entry of a post
func (service *Service) UpdatePostSingleValue(postID, columnName string, columnValue interface{}) error {
	post := entity.Post{ID: postID}
	err := service.postRepo.UpdateValue(&post, columnName, columnValue)
	if err != nil {
		return errors.New("unable to update post")
	}

	return nil
}

// ApproveOrDecline is a method that mark a post as opened or declined
func (service *Service) ApproveOrDecline(postID, status string) (*entity.Post, error) {

	post, err := service.postRepo.Find(postID)
	if err != nil {
		return nil, errors.New("post not found")
	}

	if post.Status != entity.PostStatusPending ||
		(status != entity.PostStatusDecelined && status != entity.PostStatusOpened) {
		return nil, errors.New("unable to perform operation")
	}

	post.Status = status
	err = service.postRepo.Update(post)
	if err != nil {
		return nil, errors.New("unable to update post")
	}

	return post, nil
}

// DeletePost is a method that deletes a post from the system
func (service *Service) DeletePost(postID string) (*entity.Post, error) {

	post, err := service.postRepo.Delete(postID)
	if err != nil {
		return nil, errors.New("unable to delete post")
	}

	return post, nil
}
