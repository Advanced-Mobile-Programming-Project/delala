package tools

import (
	"fmt"
	"math/rand"
	"regexp"
	"time"
)

// RandomStringGN is a function that generate a random string based on a given length.
func RandomStringGN(length int) string {
	charset := "abcdefghijklmnopqrstuvwxyz" +
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

	seededRand := rand.New(rand.NewSource(time.Now().UnixNano()))
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}

// GenerateRandomBytes returns securely generated random bytes.
func GenerateRandomBytes(n int) ([]byte, error) {
	rand.Seed(time.Now().UnixNano())
	b := make([]byte, n)
	_, err := rand.Read(b)
	if err != nil {
		return nil, err
	}
	return b, nil
}

// GenerateOTP is a function that generates a random otp value of 4 digits
func GenerateOTP() string {
	rand.Seed(time.Now().UnixNano())
	nBig := rand.Int63n(8999)
	return fmt.Sprintf("%d", nBig+1000)
}

// IDWOutPrefix is a function that returns an id without it's prefix
func IDWOutPrefix(id string) string {

	var output string
	prefixes := []string{`UR_API-`, `UR_Token-`, `UR_LA-`, `ST-`, `UR-`}

	for _, prefix := range prefixes {

		match, _ := regexp.MatchString(`^`+prefix, regexp.QuoteMeta(id))
		if match {

			rx := regexp.MustCompile(prefix)
			output = rx.ReplaceAllString(id, "")

			break
		}

	}

	return output
}
