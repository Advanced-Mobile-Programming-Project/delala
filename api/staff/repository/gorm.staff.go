package repository

import (
	"fmt"
	"math"
	"regexp"
	"strings"

	"github.com/delala/api/entity"
	"github.com/delala/api/staff"
	"github.com/delala/api/tools"

	"github.com/jinzhu/gorm"
)

// StaffRepository is a type that defines a staff repository type
type StaffRepository struct {
	conn *gorm.DB
}

// NewStaffRepository is a function that creates a new staff repository type
func NewStaffRepository(connection *gorm.DB) staff.IStaffRepository {
	return &StaffRepository{conn: connection}
}

// Create is a method that adds a new staff member to the database
func (repo *StaffRepository) Create(newStaffMember *entity.Staff) error {
	totalNumOfMember := tools.CountMembers("staffs", repo.conn)
	newStaffMember.ID = fmt.Sprintf("ST-%s%d", tools.RandomStringGN(7), totalNumOfMember+1)

	for !tools.IsUnique("id", newStaffMember.ID, "staffs", repo.conn) {
		totalNumOfMember++
		newStaffMember.ID = fmt.Sprintf("ST-%s%d", tools.RandomStringGN(7), totalNumOfMember+1)
	}

	err := repo.conn.Create(newStaffMember).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that finds a certain staff member from the database using an identifier,
// also Find() uses id, email, phone_number as a key for selection
func (repo *StaffRepository) Find(identifier string) (*entity.Staff, error) {

	modifiedIdentifier := identifier
	splitIdentifier := strings.Split(identifier, "")
	if splitIdentifier[0] == "0" {
		modifiedIdentifier = "+251" + strings.Join(splitIdentifier[1:], "")
	}

	staffMember := new(entity.Staff)
	err := repo.conn.Model(staffMember).
		Where("id = ? || email = ? || phone_number = ?", identifier, identifier, modifiedIdentifier).
		First(staffMember).Error

	if err != nil {
		return nil, err
	}
	return staffMember, nil
}

// FindAll is a method that returns set of staff members limited to the page number and role type
func (repo *StaffRepository) FindAll(role string, pageNum int64) ([]*entity.Staff, int64) {

	var staffMembers []*entity.Staff
	var count float64

	if role == entity.RoleAny {
		repo.conn.Raw("SELECT * FROM staffs ORDER BY first_name ASC LIMIT ?, 20", pageNum*20).Scan(&staffMembers)
		repo.conn.Raw("SELECT COUNT(*) FROM staffs").Count(&count)

	} else {
		repo.conn.Raw("SELECT * FROM staffs WHERE role = ? ORDER BY first_name ASC LIMIT ?, 20", role, pageNum*20).Scan(&staffMembers)
		repo.conn.Raw("SELECT COUNT(*) FROM staffs WHERE role = ?", role).Count(&count)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return staffMembers, pageCount
}

// SearchWRegx is a method that searchs and returns set of staff members limited to the key identifier, page number an role using regular expersions
func (repo *StaffRepository) SearchWRegx(key, role string, pageNum int64, columns ...string) ([]*entity.Staff, int64) {
	var staffMembers []*entity.Staff
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s regexp ? ", column))
		sqlValues = append(sqlValues, "^"+regexp.QuoteMeta(key))
	}

	if role == entity.RoleAny {

		repo.conn.Raw("SELECT COUNT(*) FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY first_name ASC LIMIT ?, 20",
			sqlValues...).Scan(&staffMembers)

	} else {

		sqlValues = append(sqlValues, role)
		repo.conn.Raw("SELECT COUNT(*) FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") && role = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") && role = ? ORDER BY first_name ASC LIMIT ?, 20",
			sqlValues...).Scan(&staffMembers)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return staffMembers, pageCount
}

// Search is a method that searchs and returns set of staff members limited to the key identifier, page number an role
func (repo *StaffRepository) Search(key, role string, pageNum int64, columns ...string) ([]*entity.Staff, int64) {
	var staffMembers []*entity.Staff
	var whereStmt []string
	var sqlValues []interface{}
	var count float64

	for _, column := range columns {

		// modifying the key so that it can match the database phone number values
		if column == "phone_number" {
			splitKey := strings.Split(key, "")
			if splitKey[0] == "0" {
				modifiedKey := "+251" + strings.Join(splitKey[1:], "")
				whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
				sqlValues = append(sqlValues, modifiedKey)
				continue
			}
		}
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	if role == entity.RoleAny {

		repo.conn.Raw("SELECT COUNT(*) FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") ", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY first_name ASC LIMIT ?, 20", sqlValues...).Scan(&staffMembers)

	} else {
		sqlValues = append(sqlValues, role)
		repo.conn.Raw("SELECT COUNT(*) FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") && role = ?", sqlValues...).Count(&count)

		sqlValues = append(sqlValues, pageNum*20)
		repo.conn.Raw("SELECT * FROM staffs WHERE ("+strings.Join(whereStmt, "||")+") && role = ? ORDER BY first_name ASC LIMIT ?, 20", sqlValues...).Scan(&staffMembers)
	}

	var pageCount int64 = int64(math.Ceil(count / 20.0))
	return staffMembers, pageCount
}

// Update is a method that updates a certain staff member value in the database
func (repo *StaffRepository) Update(staffMember *entity.Staff) error {

	prevStaffMember := new(entity.Staff)
	err := repo.conn.Model(prevStaffMember).Where("id = ?", staffMember.ID).First(prevStaffMember).Error

	if err != nil {
		return err
	}

	/* --------------------------- can change layer if needed --------------------------- */
	if staffMember.ProfilePic == "" {
		staffMember.ProfilePic = prevStaffMember.ProfilePic
	}

	staffMember.Role = prevStaffMember.Role
	staffMember.CreatedAt = prevStaffMember.CreatedAt

	/* -------------------------------------- end --------------------------------------- */

	err = repo.conn.Save(staffMember).Error
	if err != nil {
		return err
	}
	return nil
}

// UpdateValue is a method that updates a certain staff member single column value in the database
func (repo *StaffRepository) UpdateValue(staffMember *entity.Staff, columnName string, columnValue interface{}) error {

	prevStaffMember := new(entity.Staff)
	err := repo.conn.Model(prevStaffMember).Where("id = ?", staffMember.ID).First(prevStaffMember).Error

	if err != nil {
		return err
	}

	err = repo.conn.Model(entity.Staff{}).Where("id = ?", staffMember.ID).Update(map[string]interface{}{columnName: columnValue}).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain staff member from the database using an identifier.
// In Delete() id is only used as an key
func (repo *StaffRepository) Delete(identifier string) (*entity.Staff, error) {
	staffMember := new(entity.Staff)
	err := repo.conn.Model(staffMember).Where("id = ?", identifier).First(staffMember).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(staffMember)
	return staffMember, nil
}
