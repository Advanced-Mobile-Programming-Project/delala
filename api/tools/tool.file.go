package tools

import (
	"fmt"
	"io"
	"mime/multipart"
	"os"
	"path/filepath"
)

// RemoveFile is a function that removes a given file path from the assets folder.
func RemoveFile(filePath string) error {

	if err := os.Remove(filePath); err != nil {
		return err
	}

	return nil

}

// UploadSinglePhoto is a function that enable single photo file uploading
func UploadSinglePhoto(identifier, prevFileName string,
	reader io.Reader, fh *multipart.FileHeader) (string, error) {

	path, _ := os.Getwd()
	suffix := ""
	endPoint := 0

	for i := len(fh.Filename) - 1; i >= 0; i-- {
		if fh.Filename[i] == '.' {
			endPoint = i
			break
		}
	}

	for ; endPoint < len(fh.Filename); endPoint++ {
		suffix += string(fh.Filename[endPoint])
	}

	newFileName := fmt.Sprintf("asset_%s%s%s", identifier, RandomStringGN(3), suffix)
	for newFileName == prevFileName {
		newFileName = fmt.Sprintf("asset_%s%s%s", identifier, RandomStringGN(3), suffix)
	}

	path = filepath.Join(path, "../../assets/profilepics", newFileName)

	out, _ := os.Create(path)
	defer out.Close()

	_, err := io.Copy(out, reader)

	if err != nil {
		return "", err
	}

	return newFileName, nil
}
