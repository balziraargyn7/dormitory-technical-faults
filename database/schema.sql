USE master;
GO

IF DB_ID('dorm_service') IS NOT NULL
BEGIN
    ALTER DATABASE dorm_service SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE dorm_service;
END
GO

CREATE DATABASE dorm_service;
GO

USE dorm_service;
GO


CREATE TABLE roles (
    id INT PRIMARY KEY,
    name NVARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE rooms (
    id INT PRIMARY KEY,
    building NVARCHAR(30) NOT NULL,
    room_number NVARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    CONSTRAINT ck_rooms_capacity CHECK (capacity BETWEEN 1 AND 6)
);

CREATE TABLE users (
    id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20) NULL,
    role_id INT NOT NULL,
    room_id INT NULL,
    specialty NVARCHAR(20) NULL,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
    CONSTRAINT fk_users_room FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE aqau_turleri (
    id INT PRIMARY KEY,
    name NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE priorities (
    id INT PRIMARY KEY,
    name NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE statuses (
    id INT PRIMARY KEY,
    name NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE requests (
    id INT PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    technician_id INT NULL,
    aqau_turi_id INT NOT NULL,
    priority_id INT NOT NULL,
    status_id INT NOT NULL,
    description NVARCHAR(200) NOT NULL,
    created_at DATETIME2 NOT NULL,
    closed_at DATETIME2 NULL,
    CONSTRAINT fk_requests_student FOREIGN KEY (student_id) REFERENCES users(id),
    CONSTRAINT fk_requests_room FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_requests_technician FOREIGN KEY (technician_id) REFERENCES users(id),
    CONSTRAINT fk_requests_aqau FOREIGN KEY (aqau_turi_id) REFERENCES aqau_turleri(id),
    CONSTRAINT fk_requests_priority FOREIGN KEY (priority_id) REFERENCES priorities(id),
    CONSTRAINT fk_requests_status FOREIGN KEY (status_id) REFERENCES statuses(id),
    CONSTRAINT ck_requests_dates CHECK (closed_at IS NULL OR closed_at >= created_at)
);

CREATE TABLE request_history (
    id INT PRIMARY KEY,
    request_id INT NOT NULL,
    status_id INT NOT NULL,
    changed_by INT NOT NULL,
    comment NVARCHAR(200) NULL,
    changed_at DATETIME2 NOT NULL,
    CONSTRAINT fk_history_request FOREIGN KEY (request_id) REFERENCES requests(id),
    CONSTRAINT fk_history_status FOREIGN KEY (status_id) REFERENCES statuses(id),
    CONSTRAINT fk_history_user FOREIGN KEY (changed_by) REFERENCES users(id)
);

CREATE TABLE ratings (
    id INT PRIMARY KEY,
    request_id INT NOT NULL UNIQUE,
    score INT NOT NULL,
    comment NVARCHAR(200) NULL,
    CONSTRAINT fk_ratings_request FOREIGN KEY (request_id) REFERENCES requests(id),
    CONSTRAINT ck_ratings_score CHECK (score BETWEEN 1 AND 5)
);
GO