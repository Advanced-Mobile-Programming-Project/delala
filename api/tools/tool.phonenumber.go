package tools

import (
	"regexp"
	"strings"
)

// OnlyPhoneNumber is a function that returns only the phone number from the given string data
func OnlyPhoneNumber(num string) string {
	reg, _ := regexp.Compile("[^+0-9]+")
	processedString := reg.ReplaceAllString(num, "")
	return processedString
}

// GetCountryCode is a function that returns only the country code from the provided string data.
// Some phone numbers have country code attached to their end so this function get that country code.
func GetCountryCode(num string) string {
	reg, _ := regexp.Compile(`\[[a-zA-Z]{2}]$`)
	containCountryCode := reg.MatchString(num)
	if containCountryCode {
		countryCode := reg.FindString(num)
		countryCode = strings.ReplaceAll(countryCode, "[", "")
		countryCode = strings.ReplaceAll(countryCode, "]", "")
		return strings.ToUpper(countryCode)
	}

	return ""
}
