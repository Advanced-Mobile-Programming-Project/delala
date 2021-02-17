CREATE TABLE posts (
    id VARCHAR(255) PRIMARY KEY UNIQUE NOT NULL,
    user_id VARCHAR(255),
    title VARCHAR(255),
    description VARCHAR(255),
    category VARCHAR(255),
    status VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);