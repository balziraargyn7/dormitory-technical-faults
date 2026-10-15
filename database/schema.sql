-- Dorm Service: қарапайым дерекқор (SQL Server)

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

-- 1. Бөлмелер
CREATE TABLE rooms (
    id INT PRIMARY KEY,
    building NVARCHAR(30) NOT NULL,
    room_number NVARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    CONSTRAINT ck_rooms_capacity CHECK (capacity BETWEEN 1 AND 6)          -- CHECK
);

-- 2. Пайдаланушылар
CREATE TABLE users (
    id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20) NULL,
    role NVARCHAR(20) NOT NULL,
    room_id INT NULL,
    specialty NVARCHAR(20) NULL,
    CONSTRAINT ck_users_role CHECK (role IN ('student', 'commandant', 'technician', 'admin')),   -- CHECK
    CONSTRAINT fk_users_room FOREIGN KEY (room_id) REFERENCES rooms(id)                          -- FOREIGN KEY
);

-- 3. Өтінімдер
CREATE TABLE requests (
    id INT PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    technician_id INT NULL,
    fault_type NVARCHAR(20) NOT NULL,
    priority NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    description NVARCHAR(200) NOT NULL,
    created_at DATETIME2 NOT NULL,
    closed_at DATETIME2 NULL,
    rating INT NULL,
    CONSTRAINT fk_requests_student FOREIGN KEY (student_id) REFERENCES users(id),               -- FOREIGN KEY
    CONSTRAINT fk_requests_room FOREIGN KEY (room_id) REFERENCES rooms(id),                     -- FOREIGN KEY
    CONSTRAINT fk_requests_technician FOREIGN KEY (technician_id) REFERENCES users(id),         -- FOREIGN KEY
    CONSTRAINT ck_requests_fault CHECK (fault_type IN (N'электр', N'су', N'жылу', N'жиһаз')),  -- CHECK
    CONSTRAINT ck_requests_priority CHECK (priority IN (N'шұғыл', N'орташа', N'төмен')),        -- CHECK
    CONSTRAINT ck_requests_status CHECK (status IN (N'Жаңа', N'Орындалуда', N'Орындалды', N'Жабылды', N'Қайта ашылды')),  -- CHECK
    CONSTRAINT ck_requests_rating CHECK (rating IS NULL OR (rating BETWEEN 1 AND 5 AND status = N'Жабылды')),            -- CHECK
    CONSTRAINT ck_requests_dates CHECK (closed_at IS NULL OR closed_at >= created_at)           -- CHECK
);

-- 4. Өтінім тарихы
CREATE TABLE request_history (
    id INT PRIMARY KEY,
    request_id INT NOT NULL,
    status NVARCHAR(20) NOT NULL,
    changed_by INT NOT NULL,
    comment NVARCHAR(200) NULL,
    changed_at DATETIME2 NOT NULL,
    CONSTRAINT fk_history_request FOREIGN KEY (request_id) REFERENCES requests(id),             -- FOREIGN KEY
    CONSTRAINT fk_history_user FOREIGN KEY (changed_by) REFERENCES users(id),                   -- FOREIGN KEY
    CONSTRAINT ck_history_status CHECK (status IN (N'Жаңа', N'Орындалуда', N'Орындалды', N'Жабылды', N'Қайта ашылды'))  -- CHECK
);
GO