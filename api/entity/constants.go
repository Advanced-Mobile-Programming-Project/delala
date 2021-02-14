package entity

// AppSecretKeyName is a constant that defines the app secret key name
const AppSecretKeyName = "delala_secret_key"

// AppCookieName is a constant that defines the cookie name
const AppCookieName = "delala_cookie_name"

// RoleStaff is a constant that defines a staff role for a staff member table
const RoleStaff = "Staff"

// RoleAdmin is a constant that defines a admin role for a staff member table
const RoleAdmin = "Admin"

// RoleAny is a constant that defines role to be any type
const RoleAny = "Any"

// UserCategoryViewer is a constant that holds the viewer user category
const UserCategoryViewer = "Viewer"

// UserCategoryDelala is a constant that holds the delala user category
const UserCategoryDelala = "delala"

// UserCategoryAny is a constant that defines a user category to be of any type
const UserCategoryAny = "Any"

// PostStatusPending is a constant that states a post is in pending state for approval
const PostStatusPending = "P"

// PostStatusOpened is a constant that states a post has been approved and open for application
const PostStatusOpened = "O"

// PostStatusClosed is a constant that states a post is in closed state
const PostStatusClosed = "C"

// PostStatusDecelined is a constant that states a post has been decelined
const PostStatusDecelined = "D"

// PostStatusAny is a constant that defines a post status to be of any type
const PostStatusAny = "Any"

// FeedbackSeen is a constant that states a feedback has been seen
const FeedbackSeen = "Seen"

// FeedbackUnseen is a constant that states a feedback hasn't been seen
const FeedbackUnseen = "Unseen"

// StartPush is a constant that states start push
const StartPush = "Start"

// ServerLogFile is a constant that holds the server log file name
const ServerLogFile = "server.log"

// BotLogFile is a constant that holds the bot log file name
const BotLogFile = "bot.log"

// PushForApproval is a constant that states push for approval key
const PushForApproval = "Approval"

// PushToChannel is a constant that states push to channel key
const PushToChannel = "Channel"

// PushToSubscribers is a constant that states push to subscribers key
const PushToSubscribers = "Subscribers"

// ValidWorkExperiences is a value list that holds all the valid work experience
var ValidWorkExperiences = []string{"0 year", "1 year", "2 years", "3 years", "4 years",
	"5 years", "6 years", "7 years", "8 years", "9 years", "10+ years"}

// ValidContactTypes is a value list that holds all the valid contact types
var ValidContactTypes = []string{"Via Telegram Account", "Send CV"}
