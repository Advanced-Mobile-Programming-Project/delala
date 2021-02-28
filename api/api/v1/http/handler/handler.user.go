package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/delala/api/api"
	"github.com/delala/api/entity"
	"github.com/delala/api/post"
	"github.com/delala/api/tools"
	"github.com/delala/api/user"
	"github.com/go-redis/redis"
	"github.com/google/uuid"
)

// UserAPIHandler is a type that defines a user handler for api client
type UserAPIHandler struct {
	urService   user.IService
	ptService   post.IService
	redisClient *redis.Client
}

// NewUserAPIHandler is a function that returns a new user api handler
func NewUserAPIHandler(userService user.IService, postService post.IService, redisClient *redis.Client) *UserAPIHandler {
	return &UserAPIHandler{urService: userService, ptService: postService, redisClient: redisClient}
}

// HandleInitAddUser is a handler func that handles a request for initiating adding new user
func (handler *UserAPIHandler) HandleInitAddUser(w http.ResponseWriter, r *http.Request) {

	// In HandleAddUser you should not worry about receiving a profile picture since it a sign up page
	newUser := new(entity.User)
	err := json.NewDecoder(r.Body).Decode(newUser)
	if err != nil {
		output, _ := json.Marshal(map[string]string{"error": err.Error()})
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	// validating user profile and cleaning up
	errMap := handler.urService.ValidateUserProfile(newUser)

	if errMap != nil {
		output, _ := json.Marshal(errMap.StringMap())
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	otp := tools.GenerateOTP()
	smsNonce := uuid.Must(uuid.NewRandom())

	// Saving all the data to a temporary database
	tempOutput, err1 := json.Marshal(newUser)
	err2 := tools.SetValue(handler.redisClient, smsNonce.String(), otp, time.Hour*6)
	err3 := tools.SetValue(handler.redisClient, otp+smsNonce.String(), string(tempOutput), time.Hour*6)
	if err1 != nil || err2 != nil || err3 != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	fmt.Println(smsNonce.String())
	fmt.Println(otp)
	// Sending nonce to the client with the message ID, so it can be used to retrive the otp token
	output, _ := json.Marshal(map[string]string{"nonce": smsNonce.String(), "messageID": otp})
	w.WriteHeader(http.StatusOK)
	w.Write(output)
}

// HandleFinishAddUser is a handler func that handles a request for adding password and constructing user account
// This is different from the client HandleFinishAddUser because it will return an api client at the end of the request
func (handler *UserAPIHandler) HandleFinishAddUser(w http.ResponseWriter, r *http.Request) {

	newPassword := new(entity.Password)
	newUser := new(entity.User)

	nonce := r.FormValue("nonce")
	newPassword.Password = r.FormValue("password")
	vPassword := r.FormValue("vPassword")

	err := handler.urService.VerifyPassword(newPassword, vPassword)
	if err != nil {
		output, _ := json.MarshalIndent(ErrorBody{Error: err.Error()}, "", "\t")
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	storedOPUser, err := tools.GetValue(handler.redisClient, nonce)
	if err != nil {
		output, _ := json.MarshalIndent(ErrorBody{Error: "invalid token used"}, "", "\t")
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	// Removing key value pair from the redis store
	tools.RemoveValues(handler.redisClient, nonce)

	// unMarshaling user data
	json.Unmarshal([]byte(storedOPUser), newUser)

	err = handler.urService.AddUser(newUser, newPassword)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	newAPIClient := new(api.Client)
	newAPIClient.APPName = entity.APIClientAppNameInternal
	newAPIClient.Type = entity.APIClientTypeInternal
	err = handler.urService.AddAPIClient(newAPIClient, newUser)
	if err != nil {
		http.Error(w, entity.InternalAPIClientError, http.StatusInternalServerError)
		return
	}

	newAPIToken := new(api.Token)
	// newAPIToken.Scopes = entity.ScopeAll
	err = handler.urService.AddAPIToken(newAPIToken, newAPIClient, newUser)
	if err != nil {
		http.Error(w, entity.APITokenError, http.StatusInternalServerError)
		return
	}

	output, _ := json.MarshalIndent(map[string]string{"access_token": newAPIToken.AccessToken,
		"type": "Bearer", "api_key": newAPIClient.APIKey}, "", "\t")
	w.WriteHeader(http.StatusOK)
	w.Write(output)
}
