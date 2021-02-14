package staff

import (
	"net/http"

	"github.com/delala/api/client/http/session"
	"github.com/delala/api/entity"
)

// IService is a type that defines all the service methods of a staff struct
type IService interface {
	AddStaffMember(newStaffMember *entity.Staff, newPassword *entity.Password) error
	ValidateStaffMemberProfile(newStaffMember *entity.Staff) entity.ErrMap
	UpdateStaffMember(staffMember *entity.Staff) error
	UpdateStaffMemberSingleValue(staffMemberID, columnName, columnValue string) error
	FindStaffMember(identifier string) (*entity.Staff, error)
	AllStaffMembers(role string, pageNum int64) ([]*entity.Staff, int64)
	SearchStaffMembers(key, role string, pageNum int64, extra ...string) ([]*entity.Staff, int64)
	DeleteStaffMember(staffMemberID string) (*entity.Staff, error)

	AddSession(clientSession *session.ClientSession, staffMember *entity.Staff, r *http.Request) error
	FindSession(identifier string) (*session.ServerSession, error)
	SearchSession(identifier string) ([]*session.ServerSession, error)
	UpdateSession(serverSession *session.ServerSession) error
	DeleteSession(identifier string) (*session.ServerSession, error)
}
