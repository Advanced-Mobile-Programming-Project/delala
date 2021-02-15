package repository

import (
	"fmt"
	"math"
	"regexp"
	"strings"

	"github.com/delala/api/entity"
	"github.com/delala/api/feedback"
	"github.com/delala/api/tools"
	"github.com/jinzhu/gorm"
)

// FeedbackRepository is a type that defines a feedback repository type
type FeedbackRepository struct {
	conn *gorm.DB
}

// NewFeedbackRepository is a function that creates a new feedback repository type
func NewFeedbackRepository(connection *gorm.DB) feedback.IFeedbackRepository {
	return &FeedbackRepository{conn: connection}
}

// Create is a method that adds a new feedback to the database
func (repo *FeedbackRepository) Create(newFeedback *entity.Feedback) error {
	totalNumOfFeedbacks := tools.CountMembers("feedbacks", repo.conn)
	newFeedback.ID = fmt.Sprintf("FD-%s%d", tools.RandomStringGN(7), totalNumOfFeedbacks+1)

	for !tools.IsUnique("id", newFeedback.ID, "feedbacks", repo.conn) {
		totalNumOfFeedbacks++
		newFeedback.ID = fmt.Sprintf("FD-%s%d", tools.RandomStringGN(7), totalNumOfFeedbacks+1)
	}

	err := repo.conn.Create(newFeedback).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain feedback from the database using an identifier,
// also Find() uses only id as a key for selection
func (repo *FeedbackRepository) Find(identifier string) (*entity.Feedback, error) {

	feedback := new(entity.Feedback)
	err := repo.conn.Model(feedback).Where("id = ?", identifier).First(feedback).Error

	if err != nil {
		return nil, err
	}
	return feedback, nil
}

// FindMultiple is a method that finds multiple feedbacks from the database the matches the given identifier
// In FindMultiple() only user_id is used as a key
func (repo *FeedbackRepository) FindMultiple(identifier string) []*entity.Feedback {

	var feedbacks []*entity.Feedback
	err := repo.conn.Model(entity.Feedback{}).Where("user_id = ?", identifier).Find(&feedbacks).Error

	if err != nil {
		return []*entity.Feedback{}
	}
	return feedbacks
}

// FindAll is a method that returns set of feedbacks limited to the page number and status
// We used int64 for seenStatus because we have 3 options for seen value [true, false and both]
func (repo *FeedbackRepository) FindAll(seenStatus, pageNum int64) ([]*entity.Feedback, int64) {
	var feedbacks []*entity.Feedback
	var count float64

	switch seenStatus {
	case 0:
		repo.conn.Raw("SELECT * FROM feedbacks WHERE seen = ? ORDER BY created_at DESC LIMIT ?, 40", false, pageNum*40).Scan(&feedbacks)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE seen = ?", false).Count(&count)
		break
	case 1:
		repo.conn.Raw("SELECT * FROM feedbacks WHERE seen = ? ORDER BY created_at DESC LIMIT ?, 40", true, pageNum*40).Scan(&feedbacks)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE seen = ?", true).Count(&count)
		break
	default:
		repo.conn.Raw("SELECT * FROM feedbacks ORDER BY created_at DESC LIMIT ?, 40", pageNum*40).Scan(&feedbacks)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks").Count(&count)
	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return feedbacks, pageCount
}

// SearchWRegx is a method that searchs and returns set of feedbacks limited to the key identifier and page number using regular expersions
func (repo *FeedbackRepository) SearchWRegx(key string, seenStatus, pageNum int64, columns ...string) ([]*entity.Feedback, int64) {
	var feedbacks []*entity.Feedback
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s regexp ? ", column))
		sqlValues = append(sqlValues, "^"+regexp.QuoteMeta(key))
	}

	switch seenStatus {
	case 0:

		sqlValues = append(sqlValues, false)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") && seen = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" && seen = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	case 1:

		sqlValues = append(sqlValues, true)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") && seen = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" && seen = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	default:

		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return feedbacks, pageCount
}

// Search is a method that searchs and returns set of feedbacks limited to the key identifier and page number
func (repo *FeedbackRepository) Search(key string, seenStatus, pageNum int64, columns ...string) ([]*entity.Feedback, int64) {
	var feedbacks []*entity.Feedback
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	switch seenStatus {
	case 0:

		sqlValues = append(sqlValues, false)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") && seen = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" && seen = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	case 1:

		sqlValues = append(sqlValues, true)
		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") && seen = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" && seen = ? ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	default:

		repo.conn.Raw("SELECT COUNT(*) FROM feedbacks WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*40)
		repo.conn.Raw("SELECT * FROM feedbacks WHERE "+strings.Join(whereStmt, "||")+" ORDER BY created_at DESC LIMIT ?, 40", sqlValues...).Scan(&feedbacks)

	}

	var pageCount int64 = int64(math.Ceil(count / 40.0))
	return feedbacks, pageCount
}

// Update is a method that updates a certain feedback entries in the database
func (repo *FeedbackRepository) Update(feedback *entity.Feedback) error {

	prevFeedback := new(entity.Feedback)
	err := repo.conn.Model(prevFeedback).Where("id = ?", feedback.ID).First(prevFeedback).Error

	if err != nil {
		return err
	}

	/* --------------------------- can change layer if needed --------------------------- */
	feedback.CreatedAt = prevFeedback.CreatedAt
	/* -------------------------------------- end --------------------------------------- */

	err = repo.conn.Save(feedback).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain feedback from the database using an identifier.
// In Delete() id is only used as an key
func (repo *FeedbackRepository) Delete(identifier string) (*entity.Feedback, error) {
	feedback := new(entity.Feedback)
	err := repo.conn.Model(feedback).Where("id = ?", identifier).First(feedback).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(feedback)
	return feedback, nil
}

// DeleteMultiple is a method that deletes a set of feedbacks from the database using an identifier.
// In Delete() user_id is only used as an key
func (repo *FeedbackRepository) DeleteMultiple(identifier string) []*entity.Feedback {
	var feedbacks []*entity.Feedback
	repo.conn.Model(feedbacks).Where("user_id = ?", identifier).
		Find(&feedbacks)

	for _, feedback := range feedbacks {
		repo.conn.Delete(feedback)
	}

	return feedbacks
}
