package tools

import "strings"

// ToSentenceCase is a function that converts normal string to sentence case and adds full stop at the end
func ToSentenceCase(txt string) string {
	if len(txt) <= 0 {
		return ""
	}

	return strings.ToUpper(string(txt[0])) + txt[1:]
}

// ChangeSpaceToUnderscore is a function that changes all the spaces characters found in string to underscores
func ChangeSpaceToUnderscore(text string) string {
	return strings.ReplaceAll(text, " ", "_")
}

// ChangeUnderscoreToSpace is a function that changes all the underscore characters found in string to spaces
func ChangeUnderscoreToSpace(text string) string {
	return strings.ReplaceAll(text, "_", " ")
}
