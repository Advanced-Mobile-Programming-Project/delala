package api

import (
	"github.com/gorilla/mux"

	"github.com/delala/api/api/v1/http/handler"
)

// Start is a function that start the provided api version
func Start(handler *handler.UserAPIHandler, router *mux.Router) {
	userRoutes(handler, router)
}

// userRoutes is a function that defines all the routes for user profile handling
func userRoutes(handler *handler.UserAPIHandler, router *mux.Router) {

	router.HandleFunc("/api/v1/oauth/user/register/init", handler.HandleInitAddUser)

	router.HandleFunc("/api/v1/oauth/user/register/finish", handler.HandleFinishAddUser)

}
