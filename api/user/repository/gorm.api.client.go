package repository

import (
	"errors"
	"fmt"
	"strings"

	"github.com/delala/api/api"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/jinzhu/gorm"
)

// APIClientRepository is a type that defines an api client repository
type APIClientRepository struct {
	conn *gorm.DB
}

// NewAPIClientRepository is a function that returns a new api client repository
func NewAPIClientRepository(connection *gorm.DB) user.IAPIClientRepository {
	return &APIClientRepository{conn: connection}
}

// Create is a method that adds a new api client to the database
func (repo *APIClientRepository) Create(newAPIClient *api.Client) error {

	newAPIClient.APIKey = fmt.Sprintf("UR_API-%s%s", tools.IDWOutPrefix(newAPIClient.ClientUserID)+"_", tools.GenerateRandomString(7))

	for !repo.IsUnique("api_key", newAPIClient.APIKey) {
		newAPIClient.APIKey = fmt.Sprintf("UR_API-%s%s", tools.IDWOutPrefix(newAPIClient.ClientUserID)+"_", tools.GenerateRandomString(7))
	}

	err := repo.conn.Create(newAPIClient).Error
	if err != nil {
		return err
	}
	return nil
}

// Find is a method that find an api client from the database using an identifier.
// In Find() api_key is only used as a key
func (repo *APIClientRepository) Find(identifier string) (*api.Client, error) {

	apiClient := new(api.Client)
	err := repo.conn.Model(apiClient).
		Where("api_key = ?", identifier).
		First(apiClient).Error

	if err != nil {
		return nil, err
	}

	return apiClient, nil
}

// Search is a method that searchs an api client from the database using an identifier.
// In Search() client_user_id  is only used as a key
func (repo *APIClientRepository) Search(identifier string) ([]*api.Client, error) {
	var apiClients []*api.Client
	err := repo.conn.Model(api.Client{}).
		Where("client_user_id = ?", identifier).
		Find(&apiClients).Error

	if err != nil {
		return nil, err
	}

	if len(apiClients) == 0 {
		return nil, errors.New("no available api client for the provided identifier")
	}
	return apiClients, nil
}

// SearchMultiple is a method that search and returns a set of api clients from that matchs the key identifier.
func (repo *APIClientRepository) SearchMultiple(key string, pageNum int64, columns ...string) []*api.Client {

	var apiClients []*api.Client
	var whereStmt []string
	var sqlValues []interface{}

	for _, column := range columns {
		whereStmt = append(whereStmt, fmt.Sprintf(" %s = ? ", column))
		sqlValues = append(sqlValues, key)
	}

	sqlValues = append(sqlValues, pageNum*30)
	repo.conn.Raw("SELECT * FROM api_clients WHERE ("+strings.Join(whereStmt, "||")+") ORDER BY api_key ASC LIMIT ?, 30", sqlValues...).Scan(&apiClients)

	return apiClients
}

// All is a method that returns all the api_clients from the database limited with the pageNum
func (repo *APIClientRepository) All(pageNum int64) []*api.Client {

	var apiClients []*api.Client
	limit := pageNum * 30

	repo.conn.Raw("SELECT * FROM api_clients ORDER BY api_key ASC LIMIT ?, 30", limit).Scan(&apiClients)
	return apiClients
}

// Update is a method that updates an api client value in the database
func (repo *APIClientRepository) Update(apiClient *api.Client) error {

	prevAPIClient := new(api.Client)
	err := repo.conn.Model(prevAPIClient).Where("api_key = ?", apiClient.APIKey).First(prevAPIClient).Error

	if err != nil {
		return err
	}

	err = repo.conn.Model(api.Client{}).Where("api_key = ?", apiClient.APIKey).Update(apiClient).Error
	if err != nil {
		return err
	}
	return nil
}

// Delete is a method that deletes a certain api client from the database using an identifier.
// In Delete() api_key is only used as a key
func (repo *APIClientRepository) Delete(identifier string) (*api.Client, error) {
	apiClient := new(api.Client)
	err := repo.conn.Model(apiClient).Where("api_key = ?", identifier).First(apiClient).Error

	if err != nil {
		return nil, err
	}

	repo.conn.Delete(apiClient)
	return apiClient, nil
}

// DeleteMultiple is a method that deletes multiple api clients from the database using the identifier.
// In DeleteMultiple() client_user_id is only used as a key
func (repo *APIClientRepository) DeleteMultiple(identifier string) ([]*api.Client, error) {
	var apiClients []*api.Client
	err := repo.conn.Model(api.Client{}).Where("client_user_id = ?", identifier).
		Find(&apiClients).Error

	if err != nil {
		return nil, err
	}

	if len(apiClients) == 0 {
		return nil, errors.New("no api client for the provided identifier")
	}

	repo.conn.Model(api.Client{}).Where("client_user_id = ?", identifier).Delete(api.Client{})
	return apiClients, nil
}

// IsUnique is a method that determines whether a certain column value is unique in the api clients table
func (repo *APIClientRepository) IsUnique(columnName string, columnValue interface{}) bool {
	var totalCount int
	repo.conn.Model(&api.Client{}).Where(columnName+"=?", columnValue).Count(&totalCount)
	return 0 >= totalCount
}
