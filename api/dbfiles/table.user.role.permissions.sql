CREATE TABLE user_role_permissions (
    id VARCHAR(255) PRIMARY KEY UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    permission_id VARCHAR(255)
);