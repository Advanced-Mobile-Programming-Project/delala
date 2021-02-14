package tools

import (
	"net/http"

	"github.com/delala/api/entity"
)

// MiddlewareFactory is a function that propagates multiple middlewares to one handler function
func MiddlewareFactory(next http.HandlerFunc, middlewares ...entity.Middleware) http.HandlerFunc {
	for _, m := range middlewares {
		next = m(next)
	}

	return next
}
