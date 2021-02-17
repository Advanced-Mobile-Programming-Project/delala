package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strconv"

	"github.com/delala/api/api"
	v1 "github.com/delala/api/api/v1"
	"github.com/delala/api/client/http/session"
	"github.com/delala/api/entity"
	"github.com/go-redis/redis"
	"github.com/gorilla/mux"

	cmRepository "github.com/delala/api/common/repository"

	ptRepository "github.com/delala/api/post/repository"
	ptService "github.com/delala/api/post/service"

	urRepository "github.com/delala/api/user/repository"
	urService "github.com/delala/api/user/service"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"

	urAPIHandler "github.com/delala/api/api/v1/http/handler"
)

var (
	configFilesDir string
	redisClient    *redis.Client
	mysqlDB        *gorm.DB
	sysConfig      SystemConfig
	err            error

	userAPIHandler *urAPIHandler.UserAPIHandler
)

// SystemConfig is a type that defines a server system configuration file
type SystemConfig struct {
	RedisClient map[string]string `json:"redis_client"`
	MysqlClient map[string]string `json:"mysql_client"`
	DomainName  string            `json:"domain_name"`
	ServerPort  string            `json:"server_port"`
}

// initServer initialize the web server for takeoff
func initServer() {

	// Reading data from config.server.json file and creating the systemconfig  object
	sysConfigDir := filepath.Join(configFilesDir, "/config.server.json")
	sysConfigData, err := ioutil.ReadFile(sysConfigDir)

	err = json.Unmarshal(sysConfigData, &sysConfig)
	if err != nil {
		panic(err)
	}

	// Setting environmental variables so they can be used any where on the application
	os.Setenv("config_files_dir", configFilesDir)
	os.Setenv("domain_name", sysConfig.DomainName)
	os.Setenv("server_port", sysConfig.ServerPort)

	// Initializing the database with the needed tables and values
	initDB()

	passwordRepo := urRepository.NewPasswordRepository(mysqlDB)
	apiClientRepo := urRepository.NewAPIClientRepository(mysqlDB)
	apiTokenRepo := urRepository.NewAPITokenRepository(mysqlDB)
	userRepo := urRepository.NewUserRepository(mysqlDB)
	userRole := urRepository.NewUserRoleRepository(mysqlDB)
	postRepo := ptRepository.NewPostRepository(mysqlDB)
	postAttributeRepo := ptRepository.NewPostAttributeRepository(mysqlDB)
	commonRepo := cmRepository.NewCommonRepository(mysqlDB)

	userService := urService.NewUserService(userRepo, passwordRepo, apiClientRepo,
		apiTokenRepo, postRepo, userRole, commonRepo)
	postService := ptService.NewPostService(postRepo, userRepo, postAttributeRepo)

	userAPIHandler = urAPIHandler.NewUserAPIHandler(userService, postService)
}

// initDB initialize the database for takeoff
func initDB() {

	redisDB, err := strconv.ParseInt(sysConfig.RedisClient["database"], 0, 0)
	redisClient = redis.NewClient(&redis.Options{
		Addr:     sysConfig.RedisClient["address"] + ":" + sysConfig.RedisClient["port"],
		Password: sysConfig.RedisClient["password"], // no password set
		DB:       int(redisDB),                      // use default DB
	})

	if err != nil {
		panic(err)
	}

	mysqlDB, err = gorm.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local",
		sysConfig.MysqlClient["user"], sysConfig.MysqlClient["password"],
		sysConfig.MysqlClient["address"], sysConfig.MysqlClient["port"], sysConfig.MysqlClient["database"]))

	if err != nil {
		panic(err)
	}

	fmt.Println("Connected to the database: mysql @GORM")

	// Creating and Migrating tables from the structures
	mysqlDB.AutoMigrate(&entity.Password{})
	mysqlDB.AutoMigrate(&session.ServerSession{})
	mysqlDB.AutoMigrate(&api.Client{})
	mysqlDB.AutoMigrate(&api.Token{})
	mysqlDB.AutoMigrate(&entity.UserPermission{})
	mysqlDB.AutoMigrate(&entity.UserRolePermission{})
	mysqlDB.AutoMigrate(&entity.User{})
	mysqlDB.AutoMigrate(&entity.Attachment{})
	mysqlDB.AutoMigrate(&entity.Post{})

	// Setting foreign key constraint
	mysqlDB.Model(&entity.UserRolePermission{}).
		AddForeignKey("permission_id", "user_permissions(id)", "CASCADE", "CASCADE")
	mysqlDB.Model(&entity.Attachment{}).
		AddForeignKey("post_id", "posts(id)", "CASCADE", "CASCADE")

}

func main() {

	configFilesDir = "C:/Users/Administrator/go/src/github.com/delala/api/config"

	// Initializing the server
	initServer()
	defer mysqlDB.Close()

	router := mux.NewRouter()

	v1.Start(userAPIHandler, router)

	http.ListenAndServe(":"+os.Getenv("server_port"), router)
}
