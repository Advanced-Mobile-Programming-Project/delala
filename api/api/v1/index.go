package api

import (
	"github.com/gorilla/mux"

	"github.com/delala/api/api/v1/http/handler"
)

// Start is a function that start the provided api version
func Start(handler *handler.UserAPIHandler, router *mux.Router) {
}
