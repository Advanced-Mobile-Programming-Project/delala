package service

import (
	"errors"
	"net/http"
	"regexp"

	"github.com/delala/api/client/http/session"
	"github.com/delala/api/entity"
)

// AddSession is a method that adds a new staff member session to the system using the client side session
func (service *Service) AddSession(clientSession *session.ClientSession, staffMember *entity.Staff, r *http.Request) error {

	serverSession := new(session.ServerSession)
	serverSession.SessionID = clientSession.SessionID
	serverSession.UserID = staffMember.ID
	serverSession.DeviceInfo = r.UserAgent()
	serverSession.IPAddress = r.Host

	err := service.sessionRepo.Create(serverSession)
	if err != nil {
		return errors.New("unable to add new session")
	}
	return nil
}

// FindSession is a method that finds and return a staff member's server side session that matchs the identifier value
func (service *Service) FindSession(identifier string) (*session.ServerSession, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("empty identifier used")
	}

	serverSession, err := service.sessionRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("session not found")
	}
	return serverSession, nil
}

// SearchSession is a method that searchs and return a staff member's server side session that matchs the identifier value
func (service *Service) SearchSession(identifier string) ([]*session.ServerSession, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("empty identifier used")
	}

	serverSessions, err := service.sessionRepo.Search(identifier)
	if err != nil {
		return nil, errors.New("no session found for the provided identifier")
	}
	return serverSessions, nil
}

// UpdateSession is a method that updates a staff member's server side session
func (service *Service) UpdateSession(serverSession *session.ServerSession) error {

	err := service.sessionRepo.Update(serverSession)
	if err != nil {
		return errors.New("unable to update session")
	}
	return nil
}

// DeleteSession is a method that deletes a staff member's server side session from the system
func (service *Service) DeleteSession(identifier string) (*session.ServerSession, error) {

	serverSession, err := service.sessionRepo.Delete(identifier)
	if err != nil {
		return nil, errors.New("unable to delete session")
	}
	return serverSession, nil
}
