CREATE TABLE api_tokens(
    access_token VARCHAR PRIMARY KEY UNIQUE,
    api_key VARCHAR, -- can be used to identify the app
    user_id VARCHAR, -- for whom it is created
    expires_at INT,
    daily_expiration INT,
    deactivated int,
    created_at DATETIME,
    updated_at DATETIME
);