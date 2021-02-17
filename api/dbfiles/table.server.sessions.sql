Create table server_sessions(
    user_id VARCHAR NOT NULL,
    session_id VARCHAR PRIMARY KEY UNIQUE NOT NULL,
    ip_address VARCHAR,
    device_info VARCHAR,
    created_at DATETIME,
    updated_at DATETIME
);