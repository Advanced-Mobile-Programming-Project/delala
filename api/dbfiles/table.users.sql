CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    phone_number VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    created_at   DATETIME,
	updated_at   DATETIME
);