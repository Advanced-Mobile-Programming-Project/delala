package tools

// IStore is an interface that defines all the methods required by store
type IStore interface {
	Get(key string) string
	Add(key, value string)
	Remove(key string)
}

// MapStore is a type that stores elements as key value pair in map
type MapStore struct {
	store map[string]string
}

// NewMapStore is a function that returns a new redis store
func NewMapStore() IStore {
	return &MapStore{store: make(map[string]string)}
}

// Get is a method that gets the value for the given key
func (s *MapStore) Get(key string) string {
	return s.store[key]
}

// Add is a method that adds new key value pair
func (s *MapStore) Add(key, value string) {
	s.store[key] = value
}

// Remove is a method that removes a certain key value pair
func (s *MapStore) Remove(key string) {
	s.store[key] = ""
}
