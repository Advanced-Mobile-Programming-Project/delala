package feedback

import "github.com/delala/api/entity"

// IFeedbackRepository is an interface that defines all the repository methods of a feedback struct
type IFeedbackRepository interface {
	Create(newFeedback *entity.Feedback) error
	Find(identifier string) (*entity.Feedback, error)
	FindMultiple(identifier string) []*entity.Feedback
	FindAll(seenStatus, pageNum int64) ([]*entity.Feedback, int64)
	SearchWRegx(key string, seenStatus, pageNum int64, columns ...string) ([]*entity.Feedback, int64)
	Search(key string, seenStatus, pageNum int64, columns ...string) ([]*entity.Feedback, int64)
	Update(feedback *entity.Feedback) error
	Delete(identifier string) (*entity.Feedback, error)
	DeleteMultiple(identifier string) []*entity.Feedback
}
