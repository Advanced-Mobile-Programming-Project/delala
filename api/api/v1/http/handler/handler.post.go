package handler

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/delala/api/entity"
	"github.com/gorilla/mux"
)

// +++++++++++++++++++++++++++++++++++++ ADD POST +++++++++++++++++++++++++++++++++++++

// HandleAddPost is a handler that handles the request for adding post to the system
func (handler *UserAPIHandler) HandleAddPost(w http.ResponseWriter, r *http.Request) {

	newPost := new(entity.Post)
	newPost.Title = strings.TrimSpace(r.FormValue("title"))
	newPost.Description = strings.TrimSpace(r.FormValue("description"))
	newPost.Category = strings.TrimSpace(r.FormValue("category"))
	newPost.Status = entity.PostStatusOpened

	errMap := handler.ptService.ValidatePost(newPost)
	if errMap != nil {
		output, _ := json.Marshal(errMap.StringMap())
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	err := handler.ptService.AddPost(newPost)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	output, _ := json.Marshal(newPost)
	w.WriteHeader(http.StatusOK)
	w.Write(output)
}

// +++++++++++++++++++++++++++++++++++++ VIEW POST +++++++++++++++++++++++++++++++++++++

// HandleAllPosts is a handler that enables users to view all posts with pagenation
func (handler *UserAPIHandler) HandleAllPosts(w http.ResponseWriter, r *http.Request) {

	posts := handler.ptService.AllPosts()
	output, _ := json.MarshalIndent(map[string]interface{}{
		"Result": posts}, "", "\t")
	w.Write(output)
}

// +++++++++++++++++++++++++++++++++++++ UPDATE POST +++++++++++++++++++++++++++++++++++++

// HandleChangePostStatus is a handler that handles the request for modifying post status
func (handler *UserAPIHandler) HandleChangePostStatus(w http.ResponseWriter, r *http.Request) {

	id := mux.Vars(r)["id"]
	status := r.FormValue("status")

	switch status {
	case "approve":
		status = entity.PostStatusOpened
	case "decline":
		status = entity.PostStatusDecelined
	}

	post, err := handler.ptService.ApproveOrDecline(id, status)
	if err != nil {
		if err.Error() == "unable to update post" {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		output, _ := json.MarshalIndent(map[string]string{"error": err.Error()}, "", "\t")
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return

	}

	output, _ := json.MarshalIndent(post, "", "\t")
	w.Write(output)
}

// HandleUpdatePost is a handler func that handles a request for updating post
func (handler *UserAPIHandler) HandleUpdatePost(w http.ResponseWriter, r *http.Request) {

	id := mux.Vars(r)["id"]

	post, err := handler.ptService.FindPost(id)
	if err != nil {
		output, _ := json.MarshalIndent(map[string]string{"error": err.Error()}, "", "\t")
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	post.Title = strings.TrimSpace(r.FormValue("title"))
	post.Description = strings.TrimSpace(r.FormValue("description"))
	post.Category = strings.TrimSpace(r.FormValue("category"))

	errMap := handler.ptService.ValidatePost(post)

	if errMap != nil {
		output, _ := json.MarshalIndent(errMap.StringMap(), "", "\t")
		w.WriteHeader(http.StatusBadRequest)
		w.Write(output)
		return
	}

	err = handler.ptService.UpdatePost(post)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}

// +++++++++++++++++++++++++++++++++++++ DELETE POST +++++++++++++++++++++++++++++++++++++

// HandleDeletePost is a handler func that handles the request for deleting post
func (handler *UserAPIHandler) HandleDeletePost(w http.ResponseWriter, r *http.Request) {

	id := mux.Vars(r)["id"]

	post, err := handler.ptService.DeletePost(id)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}

	output, _ := json.MarshalIndent(post, "", "\t")
	w.WriteHeader(http.StatusOK)
	w.Write(output)

}
