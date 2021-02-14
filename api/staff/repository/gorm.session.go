package repository

import (
	"errors"
	"fmt"
	"regexp"
	"strings"

	"github.com/delala/api/client/http/session"
	"github.com/delala/api/staff"
	"github.com/jinzhu/gorm"
)

// SessionRepository is a type that defines a staff member server side session repository
type SessionRepository struct {
	conn *gorm.DB
}

// NewSessionRepository is a function that returns a new staff member server side session repository
func NewSessionRepository(connection *gorm.DB) staff.ISessionRepository {
	return &SessionRepository{conn: connection}
}

// Create is a method that adds a new staff member session to the database
func (repo *SessionRepository) Create(newStaffMemberSession *session.ServerSession) error {

	err := repo.conn.Create(newStaffMemberSession).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that find a staff member's server side sessions from the database using an identifier.
// In Find() session_id is only used as a key
func (repo *SessionRepository) Find(identifier string) (*session.ServerSession, error) {

	userSession := new(session.ServerSession)
	err := repo.conn.Model(userSession).
		Where("session_id = ?", identifier).
		Find(userSession).Error

	if err != nil {
		return nil, err
	}

	return userSession, nil
}

// Search is a method that searchs for a set of server side sessions from the database using an identifier.
// In Search() user_id is only used as a key
func (repo *SessionRepository) Search(identifier string) ([]*session.ServerSession, error) {

	var userSessions []*session.ServerSession
	err := repo.conn.Model(session.ServerSession{}).
		Where("user_id = ?", identifier).
		Find(&userSessions).Error

	if err != nil {
		return nil, err
	}

	if len(userSessions) == 0 {
		return nil, errors.New("no available session for the provided identifier")
	}
	return userSessions, nil
}

// SearchMultiple is a method that search and returns a set of server side sessions from that matchs the key identifier.
func (repo *SessionRepository) SearchMultiple(key string, pageNum int64, columns ...string) []*session.ServerSession {

	var userSessions []*session.ServerSession
	var whereStmt []string
	var sqlValues []interface{}

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	sqlValues = append(sqlValues, pageNum*30)
	repo.conn.Raw("SELECT * FROM server_sessions WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY user_id ASC LIMIT ?, 30", sqlValues...).Scan(&userSessions)

	return userSessions
}

// SearchMultipleWRegx is a method that searchs and returns set of server side sessions limited to the key identifier and page number using regular expersions
func (repo *SessionRepository) SearchMultipleWRegx(key string, pageNum int64, columns ...string) []*session.ServerSession {

	var userSessions []*session.ServerSession
	var whereStmt []string
	var sqlValues []interface{}

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s regexp ? ", column))
		sqlValues = append(sqlValues, "^"+regexp.QuoteMeta(key))
	}

	sqlValues = append(sqlValues, pageNum*30)
	repo.conn.Raw("SELECT * FROM server_sessions WHERE "+strings.Join(whereStmt, "||")+" ORDER BY user_id ASC LIMIT ?, 30", sqlValues...).Scan(&userSessions)

	return userSessions
}

// Update is a method that updates a certain staff member's server side session value in the database
func (repo *SessionRepository) Update(staffMemberSession *session.ServerSession) error {

	prevStaffMemberSession := new(session.ServerSession)
	err := repo.conn.Model(prevStaffMemberSession).Where("session_id = ?", staffMemberSession.SessionID).First(prevStaffMemberSession).Error

	if err != nil {
		return err
	}

	err = repo.conn.Model(session.ServerSession{}).Where("session_id = ?", staffMemberSession.SessionID).Update(staffMemberSession).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain staff member's server side session from the database using an identifier.
// In Delete() session_id is only used as an key
func (repo *SessionRepository) Delete(identifier string) (*session.ServerSession, error) {
	staffMemberSession := new(session.ServerSession)
	err := repo.conn.Model(session.ServerSession{}).Where("session_id = ?", identifier).First(staffMemberSession).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(staffMemberSession)
	return staffMemberSession, nil
}

// DeleteMultiple is a method that deletes multiple staff member's server side session from the database use identifier.
// In DeleteMultiple() user_id is only used as a key
func (repo *SessionRepository) DeleteMultiple(identifier string) ([]*session.ServerSession, error) {
	var staffMemberSessions []*session.ServerSession
	err := repo.conn.Model(session.ServerSession{}).Where("user_id = ?", identifier).Find(&staffMemberSessions).Error

	if err != nil {
		return nil, err
	}

	if len(staffMemberSessions) == 0 {
		return nil, errors.New("no session for the provided identifier")
	}

	repo.conn.Model(session.ServerSession{}).Where("user_id = ?", identifier).Delete(session.ServerSession{})
	return staffMemberSessions, nil
}
