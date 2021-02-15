package service

import (
	"errors"
	"regexp"
	"strconv"

	"github.com/delala/api/api"
	"github.com/delala/api/entity"
	"github.com/delala/api/tools"
)

// AddAPIClient is a method that adds a new api client to the system using the user
func (service *Service) AddAPIClient(apiClient *api.Client, user *entity.User) error {

	apiClient.ClientUserID = user.ID
	apiClient.APISecret = tools.RandomStringGN(20)

	err := service.apiClientRepo.Create(apiClient)
	if err != nil {
		return errors.New("unable to add new api client")
	}
	return nil
}

// FindAPIClient is a method that finds a client from the system using the given identifier and client type
func (service *Service) FindAPIClient(identifier string) (*api.Client, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("api client not found")
	}

	apiClient, err := service.apiClientRepo.Find(identifier)
	if err != nil {
		return nil, errors.New("api client not found")
	}

	return apiClient, nil
}

// SearchAPIClient is a method that searchs for clients from the system using the given identifier and client type
func (service *Service) SearchAPIClient(identifier, clientType string) ([]*api.Client, error) {

	empty, _ := regexp.MatchString(`^\s*$`, identifier)
	if empty {
		return nil, errors.New("no api client found for the provided identifier and filter")
	}

	apiClientsUnFiltered, err := service.apiClientRepo.Search(identifier)
	if err != nil {
		return nil, errors.New("no api client found for the provided identifier and filter")
	}

	if clientType == entity.APIClientTypeUnfiltered {
		return apiClientsUnFiltered, nil
	}

	apiClientsFiltered := make([]*api.Client, 0)
	for _, client := range apiClientsUnFiltered {
		if client.Type == clientType {
			apiClientsFiltered = append(apiClientsFiltered, client)
		}
	}

	if len(apiClientsFiltered) == 0 {
		return nil, errors.New("no api client found for the provided identifier and filter")
	}

	return apiClientsFiltered, nil
}

// SearchMultipleAPIClient is a method that searchs and returns a set of api clients related to the key identifier
func (service *Service) SearchMultipleAPIClient(key, pagination string, columns ...string) []*api.Client {

	empty, _ := regexp.MatchString(`^\s*$`, key)
	if empty {
		return []*api.Client{}
	}

	pageNum, _ := strconv.ParseInt(pagination, 0, 0)
	return service.apiClientRepo.SearchMultiple(key, pageNum, columns...)
}

// AllAPIClients is a method that returns all the api clients with pagination
func (service *Service) AllAPIClients(pagination string) []*api.Client {
	pageNum, _ := strconv.ParseInt(pagination, 0, 0)
	return service.apiClientRepo.All(pageNum)
}

// UpdateAPIClient is a method that updates a certain api client
func (service *Service) UpdateAPIClient(apiClient *api.Client) error {

	err := service.apiClientRepo.Update(apiClient)
	if err != nil {
		return errors.New("unable to update api client")
	}
	return nil
}

// DeleteAPIClient is a method that deletes a certain api client using the identifier
func (service *Service) DeleteAPIClient(identifier string) (*api.Client, error) {

	apiClient, err := service.apiClientRepo.Delete(identifier)
	if err != nil {
		return nil, errors.New("unable to delete api client")
	}
	return apiClient, nil
}

// DeleteAPIClients is a method that deletes a set of api client from the system that matchs the given identifier
func (service *Service) DeleteAPIClients(identifier string) ([]*api.Client, error) {

	apiClients, err := service.apiClientRepo.DeleteMultiple(identifier)
	if err != nil {
		return nil, errors.New("unable to delete api clients")
	}
	return apiClients, nil
}
