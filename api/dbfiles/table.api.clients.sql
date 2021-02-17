CREATE TABLE api_clients(
    client_user_id VARCHAR NOT NULL,
    api_key VARCHAR UNIQUE NOT NULL,
    api_secret VARCHAR NOT NULL,
    salt VARCHAR NOT NULL,
    app_name VARCHAR,
    type VARCHAR NOT NULL,
    created_at DATETIME,
    updated_at DATETIME
);