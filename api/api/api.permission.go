package api

import (
	"errors"
	"net/http"
	"strings"
)

// RequestScope is a function that returns the appropriate scope for the given request
func RequestScope(r *http.Request) (string, error) {

	uri := r.RequestURI

	switch {

	case strings.Contains(uri, "/profile"):
		return "profile", nil

	case strings.Contains(uri, "/session"):
		return "session", nil

	case strings.Contains(uri, "/send"):
		return "send", nil

	case strings.Contains(uri, "/receive"):
		return "receive", nil

	case strings.Contains(uri, "/pay"):
		return "pay", nil

	case strings.Contains(uri, "/wallet"):
		return "wallet", nil

	case strings.Contains(uri, "/linkedaccount"):
		return "linkedaccount", nil

	case strings.Contains(uri, "/history"):
		return "history", nil

	case strings.Contains(uri, "/moneytoken"):
		return "moneytoken", nil
	}

	return "", errors.New("request scope unknown")

}

// ValidScope is a function that checks whether the provided scope is valid or not
func ValidScope(scope string) bool {

	validScopes := []string{"profile", "session", "send", "receive", "pay",
		"wallet", "history", "linkedaccount", "moneytoken"}
	for _, validScope := range validScopes {
		if validScope == scope {
			return true
		}
	}

	return false
}
