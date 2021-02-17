package handler

import (
	"github.com/delala/api/post"
	"github.com/delala/api/user"
)

// UserAPIHandler is a type that defines a user handler for api client
type UserAPIHandler struct {
	urService user.IService
	ptService post.IService
}

// NewUserAPIHandler is a function that returns a new user api handler
func NewUserAPIHandler(userService user.IService, postService post.IService) *UserAPIHandler {
	return &UserAPIHandler{urService: userService, ptService: postService}
}
