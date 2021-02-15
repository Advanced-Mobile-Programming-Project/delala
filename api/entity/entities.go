package entity

import (
	"net/http"
	"time"
)

// User is a type that defines the user group
type User struct {
	ID          string `gorm:"primary_key; unique; not null"`
	UserName    string
	PhoneNumber string `gorm:"unique; not null"`
	Category    string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// Staff is a type that defines a staff member
type Staff struct {
	ID          string `gorm:"primary_key; unique; not null"`
	FirstName   string
	LastName    string
	PhoneNumber string `gorm:"unique; not null"`
	Email       string `gorm:"unique; not null"`
	ProfilePic  string
	Role        string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// Password is a type that defines a user password
type Password struct {
	ID        string `gorm:"primary_key; unique; not null"`
	Password  string
	Salt      string
	CreatedAt time.Time
	UpdatedAt time.Time
}

// Post is a type that defines post to be viewed
type Post struct {
	ID          string `gorm:"primary_key; unique; not null"`
	UserID      string
	Title       string
	Description string `gorm:"type:text;"`
	Category    string
	Status      string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// Attachment is a type that defines an attachment to a post
type Attachment struct {
	ID     string `gorm:"primary_key; unique; not null"`
	PostID string `gorm:"not null"`
	Asset  string
}

// Feedback is a type that defines user feedback
type Feedback struct {
	ID        string `gorm:"primary_key; unique; not null"`
	UserID    string
	Comment   string `gorm:"type:text;"`
	Seen      bool
	CreatedAt time.Time
}

// PostAttribute is a type that defines a post attribute like post category
type PostAttribute struct {
	ID   string `gorm:"primary_key; unique; not null"`
	Name string
}

// Key is a type that defines a key type that can be used a key value in context
type Key string

// ErrMap is a type that defines a map with string identifier and it's error
type ErrMap map[string]error

// StringMap is a method that returns string map corresponding to the ErrMap where the error type is converted to a string
func (errMap ErrMap) StringMap() map[string]string {
	stringMap := make(map[string]string)
	for key, value := range errMap {
		stringMap[key] = value.Error()
	}

	return stringMap
}

// Middleware is a type that defines a function that takes a handler func and return a new handler func type
type Middleware func(http.HandlerFunc) http.HandlerFunc
