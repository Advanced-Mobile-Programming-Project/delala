package entity

import (
	"net/http"
	"time"
)

// User is a type that defines the user group
type User struct {
	ID          string `gorm:"primary_key; unique; not null"`
	FirstName   string `gorm:"not null"`
	LastName    string `gorm:"not null"`
	PhoneNumber string `gorm:"unique; not null"`
	ProfilePic  string `gorm:"not null"`
	Role        string `gorm:"not null"`
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

// PostAttribute is a type that defines a post attribute like post category
type PostAttribute struct {
	ID   string
	Name string
}

// UserRole is a type that defines a user role permission
type UserRole struct {
	Name        string
	Permissions []*UserRolePermission
}

// UserRolePermission is a type that defines a user role permission
type UserRolePermission struct {
	ID           string `gorm:"primary_key; unique; not null"`
	Name         string `gorm:"not null"`
	PermissionID string
}

// UserPermission is a type that defines a user permissions( what a user can do )
type UserPermission struct {
	ID   string `gorm:"primary_key; unique; not null"`
	Name string `gorm:"not null; unique"`
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
