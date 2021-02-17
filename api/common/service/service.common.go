package service

import (
	"github.com/delala/api/common"
)

// Service is a type that defines a common service
type Service struct {
	commonRepo common.ICommonRepository
}

// NewCommonService is a function that returns a new common service
func NewCommonService(commonRepository common.ICommonRepository) common.IService {
	return &Service{commonRepo: commonRepository}
}
