-- Тестілік деректер (schema.sql орындалған соң іске қос)
USE dorm_service;
GO

INSERT INTO rooms (building, room_number) VALUES
    (N'1-жатақхана', N'101'),
    (N'1-жатақхана', N'102'),
    (N'1-жатақхана', N'205');

-- role_id: 1 = student, 2 = commandant, 3 = technician, 4 = admin
INSERT INTO users (full_name, email, telegram_id, role_id, room_id, specialty) VALUES
    (N'Айгерім Нұрлан',  N'aigerim@example.com',  100000001, 1, 1, NULL),
    (N'Данияр Сәрсен',   N'daniyar@example.com',  100000002, 1, 2, NULL),
    (N'Мадина Қайрат',   N'madina@example.com',   100000003, 1, 3, NULL),
    (N'Берік Асанов',    N'berik@example.com',    100000004, 2, NULL, NULL),
    (N'Ермек Жұмабек',   N'ermek@example.com',    100000005, 3, NULL, N'electrician'),
    (N'Серік Ахмет',     N'serik@example.com',    100000006, 3, NULL, N'plumber'),
    (N'Жүйе әкімшісі',   N'admin@example.com',    100000007, 4, NULL, NULL);

-- fault_type_id: 1 Электр, 2 Су, 3 Жылу, 4 Жиһаз
-- priority_id: 1 шұғыл, 2 орташа, 3 төмен
-- status_id: 1 Жаңа, 2 Орындалуда, 3 Материал күтуде, 4 Орындалды,
--            5 Жабылды, 6 Қайта ашылды, 7 Мерзімі өткен
INSERT INTO requests
    (student_id, room_id, fault_type_id, priority_id, status_id, technician_id,
     description, created_at, deadline, closed_at)
VALUES
    (1, 1, 1, 2, 5, 5, N'Шам жанбайды',
        '2026-10-01 09:00', '2026-10-02 09:00', '2026-10-01 15:30'),
    (2, 2, 2, 1, 2, 6, N'Кран ағып тұр, су еденге төгіліп жатыр',
        '2026-10-10 08:00', '2026-10-10 10:00', NULL),
    (3, 3, 3, 2, 1, NULL, N'Батарея жылымайды',
        '2026-10-11 10:00', '2026-10-12 10:00', NULL);

INSERT INTO request_history (request_id, status_id, changed_by, comment, changed_at) VALUES
    (1, 1, 1, N'Өтінім жіберілді',  '2026-10-01 09:00'),
    (1, 2, 5, N'Техник қабылдады',  '2026-10-01 11:00'),
    (1, 4, 5, N'Шам ауыстырылды',   '2026-10-01 15:00'),
    (1, 5, 1, N'Студент растады',   '2026-10-01 15:30'),
    (2, 1, 2, N'Өтінім жіберілді',  '2026-10-10 08:00'),
    (2, 2, 6, N'Техник қабылдады',  '2026-10-10 08:30'),
    (3, 1, 3, N'Өтінім жіберілді',  '2026-10-11 10:00');

INSERT INTO ratings (request_id, score, comment) VALUES
    (1, 5, N'Жылдам жөндеді');
GO