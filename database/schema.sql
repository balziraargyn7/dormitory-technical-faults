-- Dorm Service: дерекқор құрылымы (Microsoft SQL Server)

IF DB_ID('dorm_service') IS NULL
    CREATE DATABASE dorm_service;
GO

USE dorm_service;
GO

CREATE TABLE roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(30) NOT NULL UNIQUE          -- student, commandant, technician, admin
);

CREATE TABLE rooms (
    id INT IDENTITY(1,1) PRIMARY KEY,
    building NVARCHAR(20) NOT NULL,
    room_number NVARCHAR(10) NOT NULL,
    UNIQUE (building, room_number)
);

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NULL,
    telegram_id BIGINT NULL,
    role_id INT NOT NULL REFERENCES roles(id),
    room_id INT NULL REFERENCES rooms(id),     -- студент үшін
    specialty NVARCHAR(30) NULL,               -- техник үшін: electrician, plumber, carpenter
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- SQL Server-де UNIQUE бағанда тек бір NULL рұқсат, сондықтан фильтрлі индекс
CREATE UNIQUE INDEX ux_users_email ON users(email) WHERE email IS NOT NULL;
CREATE UNIQUE INDEX ux_users_telegram ON users(telegram_id) WHERE telegram_id IS NOT NULL;
GO

CREATE TABLE fault_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,                -- электр, су, жылу
    specialty NVARCHAR(30) NOT NULL            -- қай маманға бағытталады
);

CREATE TABLE priorities (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20) NOT NULL UNIQUE,         -- шұғыл, орташа, төмен
    sla_hours INT NOT NULL                     -- орындау мерзімі (сағат)
);

CREATE TABLE statuses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE requests (
    id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL REFERENCES users(id),
    room_id INT NOT NULL REFERENCES rooms(id),
    fault_type_id INT NOT NULL REFERENCES fault_types(id),
    priority_id INT NOT NULL REFERENCES priorities(id),
    status_id INT NOT NULL REFERENCES statuses(id),
    technician_id INT NULL REFERENCES users(id),
    description NVARCHAR(MAX) NOT NULL,
    photo_url NVARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deadline DATETIME2 NULL,
    closed_at DATETIME2 NULL
);

CREATE TABLE request_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
    status_id INT NOT NULL REFERENCES statuses(id),
    changed_by INT NULL REFERENCES users(id),
    comment NVARCHAR(MAX) NULL,
    changed_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE ratings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL UNIQUE REFERENCES requests(id),
    score INT NOT NULL CHECK (score BETWEEN 1 AND 5),
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- Бастапқы деректер
-- roles: 1 = student, 2 = commandant, 3 = technician, 4 = admin
INSERT INTO roles (name) VALUES
    (N'student'),
    (N'commandant'),
    (N'technician'),
    (N'admin');

INSERT INTO priorities (name, sla_hours) VALUES
    (N'шұғыл', 2),
    (N'орташа', 24),
    (N'төмен', 72);

INSERT INTO statuses (name) VALUES
    (N'Жаңа'),
    (N'Орындалуда'),
    (N'Материал күтуде'),
    (N'Орындалды'),
    (N'Жабылды'),
    (N'Қайта ашылды'),
    (N'Мерзімі өткен');

INSERT INTO fault_types (name, specialty) VALUES
    (N'Электр', N'electrician'),
    (N'Су', N'plumber'),
    (N'Жылу', N'plumber'),
    (N'Жиһаз', N'carpenter');
GO