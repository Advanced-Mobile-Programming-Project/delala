package tools

import (
	"errors"

	"github.com/dgrijalva/jwt-go"
)

// GenerateToken generates jwt token signed with a secret key
func GenerateToken(signingKey []byte, claims jwt.Claims) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signedString, err := token.SignedString(signingKey)
	return signedString, err
}

// VerifyToken is a function that generate a valid claim from a signedToken
func VerifyToken(signedToken string, signingKey []byte) bool {

	token, err := jwt.Parse(signedToken, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("error in signing method")
		}
		return signingKey, nil
	})

	if err != nil {
		return false
	}

	if _, ok := token.Claims.(jwt.Claims); !ok || !token.Valid {
		return false
	}

	return true
}
