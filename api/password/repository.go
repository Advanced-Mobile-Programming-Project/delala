package password

import "github.com/delala/api/entity"

// IPasswordRepository is an interface that defines all the repository methods of a password struct
type IPasswordRepository interface {
	Create(newMemberPassword *entity.Password) error
	Find(identifier string) (*entity.Password, error)
	Update(memberPassword *entity.Password) error
	Delete(identifier string) (*entity.Password, error)
}
