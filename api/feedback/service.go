package feedback

import "github.com/delala/api/entity"

// IService is an interface that defines all the service methods of a feedback struct
type IService interface {
	AddFeedback(newFeedback *entity.Feedback) error
	ValidateFeedback(feedback *entity.Feedback) entity.ErrMap
	FindFeedback(id string) (*entity.Feedback, error)
	FindMultipleFeedbacks(userID string) []*entity.Feedback
	AllFeedbacks(status string, pageNum int64) ([]*entity.Feedback, int64)
	SearchFeedbacks(key, status string, pageNum int64, extra ...string) ([]*entity.Feedback, int64)
	MarkAsSeen(feedbackID string) error
	DeleteFeedback(id string) (*entity.Feedback, error)
	DeleteMultipleFeedbacks(userID string) []*entity.Feedback
}
