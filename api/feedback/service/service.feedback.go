package service

import (
	"errors"
	"regexp"

	"github.com/delala/api/entity"
	"github.com/delala/api/feedback"
	"github.com/delala/api/user"
)

// Service is a type that defines a feedback service
type Service struct {
	feedbackRepo feedback.IFeedbackRepository
	userRepo     user.IUserRepository
}

// NewFeedbackService is a function that returns a new feedback service
func NewFeedbackService(feedbackRepository feedback.IFeedbackRepository,
	userRepository user.IUserRepository) feedback.IService {
	return &Service{feedbackRepo: feedbackRepository, userRepo: userRepository}
}

// AddFeedback is a method that adds a new feedback to the system
func (service *Service) AddFeedback(newFeedback *entity.Feedback) error {

	err := service.feedbackRepo.Create(newFeedback)
	if err != nil {
		return errors.New("unable to add new feedback")
	}

	return nil
}

// ValidateFeedback is a method that validates a feedback entries.
// It checks if the feedback has a valid entries or not and return map of errors if any.
func (service *Service) ValidateFeedback(feedback *entity.Feedback) entity.ErrMap {

	errMap := make(map[string]error)

	emptyComment, _ := regexp.MatchString(`^\s*$`, feedback.Comment)
	if emptyComment {
		errMap["comment"] = errors.New("comment can not be empty")
	} else if len(feedback.Comment) > 1000 {
		errMap["comment"] = errors.New("comment can not exceed 1000 characters")
	}

	if feedback.UserID != "" {
		_, err := service.userRepo.Find(feedback.UserID)
		if err != nil {
			errMap["user_id"] = errors.New("no user found for the provided user id")
		}
	} else {
		errMap["user_id"] = errors.New("no user found for the provided user id")
	}

	if len(errMap) > 0 {
		return errMap
	}

	return nil
}

// FindFeedback is a method that find and return a feedback that matches the id value
func (service *Service) FindFeedback(id string) (*entity.Feedback, error) {

	empty, _ := regexp.MatchString(`^\s*$`, id)
	if empty {
		return nil, errors.New("no feedback found")
	}

	feedback, err := service.feedbackRepo.Find(id)
	if err != nil {
		return nil, errors.New("no feedback found")
	}
	return feedback, nil
}

// FindMultipleFeedbacks is a method that find and return multiple feedbacks that matchs the userID value
func (service *Service) FindMultipleFeedbacks(userID string) []*entity.Feedback {

	empty, _ := regexp.MatchString(`^\s*$`, userID)
	if empty {
		return []*entity.Feedback{}
	}

	return service.feedbackRepo.FindMultiple(userID)
}

// AllFeedbacks is a method that returns all the feedbacks with pagination
func (service *Service) AllFeedbacks(status string, pageNum int64) ([]*entity.Feedback, int64) {

	var seenStatus int64
	if status == entity.FeedbackUnseen {
		seenStatus = 0
	} else if status == entity.FeedbackSeen {
		seenStatus = 1
	} else {
		seenStatus = 2
	}

	return service.feedbackRepo.FindAll(seenStatus, pageNum)
}

// SearchFeedbacks is a method that searchs and returns a set of feedbacks related to the key identifier
func (service *Service) SearchFeedbacks(key, status string, pageNum int64, extra ...string) ([]*entity.Feedback, int64) {

	var seenStatus int64
	if status == entity.FeedbackUnseen {
		seenStatus = 0
	} else if status == entity.FeedbackSeen {
		seenStatus = 1
	} else {
		seenStatus = 2
	}

	defaultSearchColumnsRegx := []string{"comment"}
	defaultSearchColumnsRegx = append(defaultSearchColumnsRegx, extra...)
	defaultSearchColumns := []string{"id", "user_id"}

	result1 := make([]*entity.Feedback, 0)
	result2 := make([]*entity.Feedback, 0)
	results := make([]*entity.Feedback, 0)
	resultsMap := make(map[string]*entity.Feedback)
	var pageCount1 int64 = 0
	var pageCount2 int64 = 0
	var pageCount int64 = 0

	empty, _ := regexp.MatchString(`^\s*$`, key)
	if empty {
		return results, 0
	}

	result1, pageCount1 = service.feedbackRepo.Search(key, seenStatus, pageNum, defaultSearchColumns...)
	if len(defaultSearchColumnsRegx) > 0 {
		result2, pageCount2 = service.feedbackRepo.SearchWRegx(key, seenStatus, pageNum, defaultSearchColumnsRegx...)
	}

	for _, feedback := range result1 {
		resultsMap[feedback.ID] = feedback
	}

	for _, feedback := range result2 {
		resultsMap[feedback.ID] = feedback
	}

	for _, uniqueFeedback := range resultsMap {
		results = append(results, uniqueFeedback)
	}

	pageCount = pageCount1
	if pageCount < pageCount2 {
		pageCount = pageCount2
	}

	return results, pageCount
}

// MarkAsSeen is a method that mark a feedback as seen
func (service *Service) MarkAsSeen(feedbackID string) error {

	feedback, err := service.feedbackRepo.Find(feedbackID)
	if err != nil {
		return errors.New("feedback not found")
	}

	if feedback.Seen {
		return errors.New("unable to perform operation")
	}

	feedback.Seen = true
	err = service.feedbackRepo.Update(feedback)
	if err != nil {
		return errors.New("unable to update feedback")
	}

	return nil
}

// DeleteFeedback is a method that deletes a feedback from the system using an id
func (service *Service) DeleteFeedback(id string) (*entity.Feedback, error) {

	feedback, err := service.feedbackRepo.Delete(id)
	if err != nil {
		return nil, errors.New("unable to delete feedback")
	}

	return feedback, nil
}

// DeleteMultipleFeedbacks is a method that deletes multiple feedbacks from the system that match the given userID
func (service *Service) DeleteMultipleFeedbacks(userID string) []*entity.Feedback {
	return service.feedbackRepo.DeleteMultiple(userID)
}
