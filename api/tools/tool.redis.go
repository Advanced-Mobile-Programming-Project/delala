package tools

import (
	"time"

	"github.com/go-redis/redis"
)

// RedisStore is a type that stores elements as key value pair in a redis database
type RedisStore struct {
	store *redis.Client
}

// NewRedisStore is a function that returns a new redis store
func NewRedisStore(redisClient *redis.Client) IStore {
	return &RedisStore{store: redisClient}
}

// Get is a method that gets the value for the given key
func (s *RedisStore) Get(key string) string {
	value, _ := s.store.Get(key).Result()
	return value
}

// Add is a method that adds new key value pair
func (s *RedisStore) Add(key, value string) {
	s.store.Set(key, value, time.Hour*24)
}

// Remove is a method that removes a certain key value pair
func (s *RedisStore) Remove(key string) {
	s.store.Del(key)
}
