package tools

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"net/http"
	"net/smtp"
	"net/url"
	"os"
	"path/filepath"
	"strings"
)

// APIClientSMS is a type that defines an api client account for sending sms
type APIClientSMS struct {
	AccountID string `json:"accountID"`
	AuthToken string `json:"authToken"`
	From      string `json:"from"`
}

// SMTPContainer is a type that defines all the entities for sending email using smtp
type SMTPContainer struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	DNS      string `json:"dns"`
	Port     string `json:"port"`
	Extra    string `json:"extra"`
}

// SendSMS is a function that sends a given message to the provide phone number
func SendSMS(to, msg string) (string, error) {

	dir := filepath.Join(os.Getenv("config_files_dir"), "/accounts/account.api.sms.json")
	data, err := ioutil.ReadFile(dir)
	if err != nil {
		return "", err
	}

	var clientAccount APIClientSMS
	err = json.Unmarshal(data, &clientAccount)
	if err != nil {
		return "", err
	}

	urlStr := "https://api.twilio.com/2010-04-01/Accounts/" + clientAccount.AccountID + "/Messages.json"

	msgData := url.Values{}
	msgData.Set("To", to)
	msgData.Set("From", clientAccount.From)
	msgData.Set("Body", msg)
	msgDataReader := *strings.NewReader(msgData.Encode())

	client := &http.Client{}
	req, _ := http.NewRequest("POST", urlStr, &msgDataReader)
	req.SetBasicAuth(clientAccount.AccountID, clientAccount.AuthToken)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		var data map[string]interface{}
		decoder := json.NewDecoder(resp.Body)
		err = decoder.Decode(&data)
		if err != nil {
			return "", err
		}

		smsID, ok := data["sid"].(string)
		if !ok {
			return "", errors.New("unable to parse the sms id")
		}
		return smsID, nil
	}

	return "", errors.New(resp.Status)
}

// SendEmail is a function that sends an email to the provided email address.
func SendEmail(to, subject, msg string) error {

	dir := filepath.Join(os.Getenv("config_files_dir"), "/accounts/account.api.email.json")
	data, err := ioutil.ReadFile(dir)
	if err != nil {
		return err
	}

	var smtpContainer SMTPContainer
	err = json.Unmarshal(data, &smtpContainer)
	if err != nil {
		return err
	}

	auth := smtp.PlainAuth(smtpContainer.Extra, smtpContainer.Email, smtpContainer.Password, smtpContainer.DNS)
	msgByte := []byte(
		"To:" + to + "\r\n" + "Subject: " + subject + "\r\n" + "\r\n" + msg)
	receiver := []string{to}

	return smtp.SendMail(smtpContainer.DNS+":"+smtpContainer.Port, auth, smtpContainer.Email, receiver, msgByte)
}
