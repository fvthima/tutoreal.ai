-- ============================================================
-- USE DATABASE
-- ============================================================
USE tutoreal;

SELECT * FROM Students;

-- ============================================================
-- DROP EXISTING TABLES
-- ============================================================
DROP TABLE IF EXISTS SessionFeedback;
DROP TABLE IF EXISTS Sessions;
DROP TABLE IF EXISTS StudentLearningPaths;
DROP TABLE IF EXISTS StudentAvailableSlots;
DROP TABLE IF EXISTS StudentSubjects;
DROP TABLE IF EXISTS TutorSubjects;
DROP TABLE IF EXISTS TutorAvailableSlots;
DROP TABLE IF EXISTS TutorReviews;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Tutors;
DROP TABLE IF EXISTS Subjects;

-- ============================================================
-- CREATE TABLES
-- ============================================================

-- 1. Subjects Table
CREATE TABLE Subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL,
    prerequisite_id INT DEFAULT NULL,
    FOREIGN KEY (prerequisite_id) REFERENCES Subjects(subject_id) ON DELETE SET NULL
);

-- 2. Tutors Table
CREATE TABLE Tutors (
    tutor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    profile_pic_url VARCHAR(255) DEFAULT '/static/images/default-profile-picture.png',
    preferred_language VARCHAR(50) NOT NULL,
    teaching_style ENUM('Read/Write', 'Auditory', 'Visual') NOT NULL,
    average_star_rating DECIMAL(3,2) CHECK (average_star_rating BETWEEN 1.00 AND 5.00),
    completed_sessions INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    earnings DECIMAL(10,2),
    qualifications TEXT,
    expertise TEXT,
    password VARCHAR(255),
    bio TEXT
);


-- 3. Students Table
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
	profile_pic_url VARCHAR(255) DEFAULT '/static/images/default-profile-picture.png',
    preferred_learning_style ENUM('Read/Write', 'Auditory', 'Visual') NOT NULL,
    preferred_language VARCHAR(50) NOT NULL,
    budget DECIMAL(10,2),
    password VARCHAR(255) NOT NULL
);

ALTER TABLE Students
ADD COLUMN about_me TEXT,
ADD COLUMN time_zone VARCHAR(100);


-- 4. TutorReviews Table
CREATE TABLE TutorReviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT,
    student_name VARCHAR(255),
    rating DECIMAL(3,2),
    comment TEXT,
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id)
);

-- 5. TutorAvailableSlots Table
CREATE TABLE TutorAvailableSlots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id)
);

-- 6. TutorSubjects Table
CREATE TABLE TutorSubjects (
    tutor_id INT,
    subject_id INT,
    price DECIMAL(10,2) NOT NULL DEFAULT 50.00,
    PRIMARY KEY (tutor_id, subject_id),
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- 7. StudentSubjects Table
CREATE TABLE StudentSubjects (
    student_id INT,
    subject_id INT,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- 8. StudentAvailableSlots Table
CREATE TABLE StudentAvailableSlots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 9. StudentLearningPaths Table
CREATE TABLE StudentLearningPaths (
    path_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    learning_item VARCHAR(255),
    step_order INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 10. Sessions Table
CREATE TABLE Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    tutor_id INT NOT NULL,
    subject_id INT NOT NULL,
    scheduled_time DATETIME NOT NULL,
    session_status ENUM('Scheduled', 'Completed', 'Canceled') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- 11. SessionFeedback Table
CREATE TABLE SessionFeedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT,
    student_feedback TEXT,
    star_rating INT CHECK (star_rating BETWEEN 1 AND 5),
    feedback_sentiment VARCHAR(20),
    feedback_issues TEXT,
    improvement_tip TEXT,
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id)
);

-- ============================================================
-- INSERT BASE SUBJECTS
-- ============================================================
INSERT INTO Subjects (subject_name, prerequisite_id) VALUES 
    ('Linear Algebra', NULL),
    ('General Chemistry', NULL),
    ('Python Programming', NULL),
    ('Database Systems', NULL),
    ('Classical Mechanics', NULL),
    ('Basic Cooking Techniques', NULL),
    ('Calculus 1', NULL),
    ('Linear Regression', NULL);

INSERT INTO Subjects (subject_name, prerequisite_id)
VALUES
  ('Calculus 2', (SELECT subject_id FROM (SELECT * FROM Subjects) AS temp WHERE subject_name = 'Calculus 1')),
  ('Organic Chemistry', (SELECT subject_id FROM (SELECT * FROM Subjects) AS temp WHERE subject_name = 'General Chemistry')),
  ('Physics', NULL),
  ('Programming', NULL),
  ('Data Structures', NULL),
  ('Algorithms', NULL),
  ('Statistics', NULL),
  ('Machine Learning', (SELECT subject_id FROM (SELECT * FROM Subjects) AS temp WHERE subject_name = 'Data Structures')),
  ('Deep Learning', (SELECT subject_id FROM (SELECT * FROM Subjects) AS temp WHERE subject_name = 'Machine Learning')),
  ('Data Structures and Algorithms', NULL);

-- ============================================================
-- INSERT TUTOR DATA
-- ============================================================

-- Tutor 1
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Alice Johnson', 'English', 'Visual', 4.3, 120, 'alice.johnson@example.com', 0.00, 'MSc Mathematics', 'Linear Regression, Calculus', 'I am Alice Johnson, a dedicated Visual tutor with an MSc in Mathematics. I specialize in Linear Regression and Calculus and have completed 120 sessions helping students master complex mathematical concepts.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00),
       (1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (1, '2025-03-21', '09:00:00', '10:00:00'),
       (1, '2025-03-22', '08:15:00', '09:15:00'),
       (1, '2025-03-23', '10:30:00', '11:30:00'),
       (1, '2025-03-25', '14:45:00', '15:45:00');


-- Tutor 2
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Bob Smith', 'Spanish', 'Auditory', 3.7, 95, 'bob.smith@example.com', 0.00, 'BSc Chemistry', 'Organic Chemistry, Physics', 'I am Bob Smith, an Auditory tutor with a BSc in Chemistry. I specialize in Organic Chemistry and Physics and have conducted 95 sessions supporting students in scientific learning.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 50.00),
       (2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 55.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (2, '2025-03-21', '09:00:00', '10:00:00'),
       (2, '2025-03-22', '09:30:00', '10:30:00'),
       (2, '2025-03-26', '11:15:00', '12:15:00'),
       (2, '2025-03-28', '14:00:00', '15:00:00');
       
-- Tutor 3
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Charlie Davis', 'English', 'Read/Write', 4.8, 200, 'charlie.davis@example.com', 0.00, 'PhD Computer Science', 'Programming, Data Structures', 'I am Charlie Davis, a Read/Write tutor holding a PhD in Computer Science. With expertise in Programming and Data Structures and 200 completed sessions, I empower students with deep technical skills.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 35.00),
       (3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (3, '2025-03-21', '09:00:00', '10:00:00'),
       (3, '2025-03-25', '10:45:00', '11:45:00'),
       (3, '2025-03-27', '13:15:00', '14:15:00'),
       (3, '2025-03-29', '16:30:00', '17:30:00');

-- Tutor 4
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Diana Evans', 'French', 'Visual', 4.1, 150, 'diana.evans@example.com', 0.00, 'MSc Computer Science', 'Algorithms, Machine Learning', 'I am Diana Evans, a Visual tutor with an MSc in Computer Science. I specialize in Algorithms and Machine Learning and have successfully conducted 150 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 45.00),
       (4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 50.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (4, '2025-03-21', '09:00:00', '10:00:00'),
       (4, '2025-03-27', '10:30:00', '11:30:00'),
       (4, '2025-03-29', '12:45:00', '13:45:00'),
       (4, '2025-03-31', '15:00:00', '16:00:00');
       
-- Tutor 5
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Edward Miller', 'German', 'Auditory', 3.9, 110, 'edward.miller@example.com', 0.00, 'BSc Mathematics', 'Statistics, Calculus', 'I am Edward Miller, an Auditory tutor with a BSc in Mathematics. I excel in teaching Statistics and Calculus 1, backed by 110 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00),
       (5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'), 35.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (5, '2025-03-21', '09:00:00', '10:00:00'),
       (5, '2025-03-30', '09:45:00', '10:45:00'),
       (5, '2025-03-23', '11:15:00', '12:15:00'),
       (5, '2025-03-25', '14:30:00', '15:30:00');


-- Tutor 6
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Fiona Garcia', 'English', 'Read/Write', 4.5, 130, 'fiona.garcia@example.com', 0.00, 'MSc Statistics', 'Linear Regression, Statistics', 'I am Fiona Garcia, a Read/Write tutor with an MSc in Statistics. I focus on Linear Regression and Statistics, and I have 130 successful sessions under my belt.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 42.00),
       (6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 38.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (6, '2025-03-21', '09:00:00', '10:00:00'),
       (6, '2025-03-22', '10:15:00', '11:15:00'),
       (6, '2025-03-24', '13:30:00', '14:30:00'),
       (6, '2025-03-26', '16:00:00', '17:00:00');
       

-- Tutor 7
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('George Harris', 'Arabic', 'Visual', 3.6, 85, 'george.harris@example.com', 0.00, 'BSc Physics', 'Organic Chemistry, Physics', 'I am George Harris, a Visual tutor with a BSc in Physics. I bring expertise in Organic Chemistry and Physics, with 85 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 48.00),
       (7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 52.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (7, '2025-03-21', '09:00:00', '10:00:00'),
       (7, '2025-03-25', '11:00:00', '12:00:00'),
       (7, '2025-03-27', '14:00:00', '15:00:00'),
       (7, '2025-03-29', '15:30:00', '16:30:00');

-- Tutor 8
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Hannah Lee', 'English', 'Auditory', 4.7, 175, 'hannah.lee@example.com', 0.00, 'BA Computer Science', 'Programming, Algorithms', 'I am Hannah Lee, an Auditory tutor with a BA in Computer Science. I specialize in Programming and Algorithms and have 175 sessions of experience.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 37.00),
       (8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (8, '2025-03-21', '09:00:00', '10:00:00'),
       (8, '2025-03-27', '10:45:00', '11:45:00'),
       (8, '2025-03-29', '12:15:00', '13:15:00'),
       (8, '2025-03-31', '15:00:00', '16:00:00');

-- Tutor 9
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Ian Walker', 'Spanish', 'Read/Write', 4.2, 140, 'ian.walker@example.com', 0.00, 'BSc Computer Science', 'Data Structures, Machine Learning', 'I am Ian Walker, a Read/Write tutor holding a BSc in Computer Science. My expertise in Data Structures and Machine Learning is backed by 140 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 40.00),
       (9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (9, '2025-03-21', '09:00:00', '10:00:00'),
       (9, '2025-03-30', '08:45:00', '09:45:00'),
       (9, '2025-03-23', '11:15:00', '12:15:00'),
       (9, '2025-03-25', '16:00:00', '17:00:00');

-- Tutor 10
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Julia Scott', 'French', 'Visual', 4.0, 100, 'julia.scott@example.com', 0.00, 'MSc Mathematics', 'Calculus 2, Linear Regression', 'I am Julia Scott, a Visual tutor with an MSc in Mathematics. I specialize in Calculus 2 and Linear Regression, having completed 100 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 44.00),
       (10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (10, '2025-03-21', '09:00:00', '10:00:00'),
       (10, '2025-03-24', '08:30:00', '09:30:00'),
       (10, '2025-03-26', '10:00:00', '11:00:00'),
       (10, '2025-03-28', '14:00:00', '15:00:00');

-- Tutor 11
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Kevin Adams', 'English', 'Auditory', 3.8, 90, 'kevin.adams@example.com', 0.00, 'BSc Chemistry', 'Organic Chemistry, Statistics', 'I am Kevin Adams, an Auditory tutor with a BSc in Chemistry. I focus on Organic Chemistry and Statistics, with 90 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (11, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 43.00),
       (11, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 39.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (11, '2025-03-21', '09:00:00', '10:00:00'),
       (11, '2025-03-26', '10:15:00', '11:15:00'),
       (11, '2025-03-28', '13:30:00', '14:30:00'),
       (11, '2025-03-29', '15:00:00', '16:00:00');

-- Tutor 12
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Laura Perez', 'Spanish', 'Read/Write', 4.6, 160, 'laura.perez@example.com', 0.00, 'MSc Computer Science', 'Programming, Calculus 2', 'I am Laura Perez, a Read/Write tutor with an MSc in Computer Science. I specialize in Programming and Calculus 2, supported by 160 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (12, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 38.00),
       (12, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (12, '2025-03-21', '09:00:00', '10:00:00'),
       (12, '2025-03-22', '08:45:00', '09:45:00'),
       (12, '2025-03-24', '10:30:00', '11:30:00'),
       (12, '2025-03-26', '14:00:00', '15:00:00');
       
-- Tutor 13
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Michael Brown', 'English', 'Visual', 4.4, 145, 'michael.brown@example.com', 0.00, 'PhD Physics', 'Physics, Machine Learning', 'I am Michael Brown, a Visual tutor holding a PhD in Physics. With expertise in Physics and Machine Learning and 145 completed sessions, I help students excel in science.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (13, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 46.00),
       (13, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 50.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (13, '2025-03-21', '09:00:00', '10:00:00'),
       (13, '2025-03-23', '10:30:00', '11:30:00'),
       (13, '2025-03-25', '12:15:00', '13:15:00'),
       (13, '2025-03-27', '15:30:00', '16:30:00');

-- Tutor 14
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Natalie Wilson', 'French', 'Auditory', 4.9, 210, 'natalie.wilson@example.com', 0.00, 'MSc Computer Science', 'Data Structures, Algorithms', 'I am Natalie Wilson, an Auditory tutor with an MSc in Computer Science. I excel in Data Structures and Algorithms, having completed 210 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (14, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 47.00),
       (14, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (14, '2025-03-21', '09:00:00', '10:00:00'),
       (14, '2025-03-24', '09:15:00', '10:15:00'),
       (14, '2025-03-26', '11:45:00', '12:45:00'),
       (14, '2025-03-28', '14:30:00', '15:30:00');

-- Tutor 15
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Oliver Martinez', 'German', 'Read/Write', 3.5, 80, 'oliver.martinez@example.com', 0.00, 'BSc Mathematics', 'Statistics, Programming', 'I am Oliver Martinez, a Read/Write tutor with a BSc in Mathematics. I specialize in Statistics and Programming and have completed 80 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (15, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00),
       (15, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (15, '2025-03-21', '09:00:00', '10:00:00'),
       (15, '2025-03-25', '10:00:00', '11:00:00'),
       (15, '2025-03-27', '13:30:00', '14:30:00'),
       (15, '2025-03-29', '15:45:00', '16:45:00');

-- Tutor 16
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Patricia Robinson', 'Arabic', 'Visual', 4.2, 115, 'patricia.robinson@example.com', 0.00, 'MBA', 'Linear Regression, Organic Chemistry', 'I am Patricia Robinson, a Visual tutor with an MBA. I focus on Linear Regression and Organic Chemistry, with 115 completed sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (16, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 41.00),
       (16, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 43.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (16, '2025-03-21', '09:00:00', '10:00:00'),
       (16, '2025-03-30', '12:00:00', '13:00:00'),
       (16, '2025-03-23', '10:30:00', '11:30:00'),
       (16, '2025-03-25', '14:15:00', '15:15:00');

-- Tutor 17
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Quentin Clark', 'English', 'Auditory', 3.9, 105, 'quentin.clark@example.com', 0.00, 'BSc Mathematics', 'Calculus, Physics', 'I am Quentin Clark, an Auditory tutor with a BSc in Mathematics. I specialize in Calculus and Physics and have completed 105 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (17, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 43.00),
       (17, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 44.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (17, '2025-03-21', '09:00:00', '10:00:00'),
       (17, '2025-03-22', '10:00:00', '11:00:00'),
       (17, '2025-03-24', '12:15:00', '13:15:00'),
       (17, '2025-03-26', '15:30:00', '16:30:00');

-- Tutor 18
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Rachel Lewis', 'Spanish', 'Read/Write', 4.8, 190, 'rachel.lewis@example.com', 0.00, 'BSc Chemistry', 'Programming, Machine Learning', 'I am Rachel Lewis, a Read/Write tutor with a BSc in Chemistry. My expertise in Programming and Machine Learning is backed by 190 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (18, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 39.00),
       (18, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 47.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (18, '2025-03-21', '09:00:00', '10:00:00'),
       (18, '2025-03-25', '09:15:00', '10:15:00'),
       (18, '2025-03-27', '11:30:00', '12:30:00'),
       (18, '2025-03-29', '14:00:00', '15:00:00');

-- Tutor 19
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Steven Young', 'French', 'Visual', 4.0, 125, 'steven.young@example.com', 0.00, 'BSc Physics', 'Data Structures, Algorithms', 'I am Steven Young, a Visual tutor holding a BSc in Physics. I specialize in Data Structures and Algorithms, with 125 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (19, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 42.00),
       (19, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (19, '2025-03-21', '09:00:00', '10:00:00'),
       (19, '2025-03-23', '10:00:00', '11:00:00'),
       (19, '2025-03-25', '12:30:00', '13:30:00'),
       (19, '2025-03-27', '15:00:00', '16:00:00');

-- Tutor 20
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Teresa King', 'German', 'Auditory', 3.7, 95, 'teresa.king@example.com', 0.00, 'BSc Chemistry', 'Organic Chemistry, Statistics', 'I am Teresa King, an Auditory tutor with a BSc in Chemistry. I focus on Organic Chemistry and Statistics, supported by 95 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (20, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 44.00),
       (20, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (20, '2025-03-21', '09:00:00', '10:00:00'),
       (20, '2025-03-24', '08:30:00', '09:30:00'),
       (20, '2025-03-26', '11:15:00', '12:15:00'),
       (20, '2025-03-28', '14:45:00', '15:45:00');

-- Tutor 21
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Umar Patel', 'Arabic', 'Read/Write', 4.3, 135, 'umar.patel@example.com', 0.00, 'MBA', 'Linear Regression, Calculus 1', 'I am Umar Patel, a Read/Write tutor with an MBA. I specialize in Linear Regression and Calculus 1, having completed 135 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (21, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00),
       (21, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'), 38.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (21, '2025-03-21', '09:00:00', '10:00:00'),
       (21, '2025-03-30', '11:15:00', '12:15:00'),
       (21, '2025-03-23', '12:30:00', '13:30:00'),
       (21, '2025-03-25', '15:00:00', '16:00:00');

-- Tutor 22
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Victoria Wright', 'English', 'Visual', 4.5, 150, 'victoria.wright@example.com', 0.00, 'MSc Computer Science', 'Programming, Data Structures', 'I am Victoria Wright, a Visual tutor with an MSc in Computer Science. I excel in Programming and Data Structures with 150 completed sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (22, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 41.00),
       (22, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (22, '2025-03-21', '09:00:00', '10:00:00'),
       (22, '2025-03-22', '09:15:00', '10:15:00'),
       (22, '2025-03-24', '11:00:00', '12:00:00'),
       (22, '2025-03-26', '14:30:00', '15:30:00');

-- Tutor 23
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Walter Baker', 'Spanish', 'Auditory', 4.1, 110, 'walter.baker@example.com', 0.00, 'BSc Mathematics', 'Algorithms, Machine Learning', 'I am Walter Baker, an Auditory tutor with a BSc in Mathematics. I specialize in Algorithms and Machine Learning and have conducted 110 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (23, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 42.00),
       (23, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 44.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (23, '2025-03-21', '09:00:00', '10:00:00'),
       (23, '2025-03-25', '10:30:00', '11:30:00'),
       (23, '2025-03-27', '13:00:00', '14:00:00'),
       (23, '2025-03-29', '15:45:00', '16:45:00');

-- Tutor 24
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Xenia Gonzalez', 'French', 'Read/Write', 4.7, 160, 'xenia.gonzalez@example.com', 0.00, 'MSc Chemistry', 'Statistics, Calculus 2', 'I am Xenia Gonzalez, a Read/Write tutor with an MSc in Chemistry. I focus on Statistics and Calculus 2, backed by 160 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (24, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00),
       (24, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (24, '2025-03-21', '09:00:00', '10:00:00'),
       (24, '2025-03-23', '08:45:00', '09:45:00'),
       (24, '2025-03-25', '10:30:00', '11:30:00'),
       (24, '2025-03-27', '13:15:00', '14:15:00');


-- Tutor 25
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Yvonne Rivera', 'German', 'Visual', 3.8, 90, 'yvonne.rivera@example.com', 0.00, 'BSc Engineering', 'Organic Chemistry, Physics', 'I am Yvonne Rivera, a Visual tutor with a BSc in Engineering. I specialize in Organic Chemistry and Physics, with 90 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (25, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 45.00),
       (25, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 47.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (25, '2025-03-21', '09:00:00', '10:00:00'),
       (25, '2025-03-24', '13:15:00', '14:15:00'),
       (25, '2025-03-26', '15:00:00', '16:00:00'),
       (25, '2025-03-28', '16:30:00', '17:30:00');

-- Tutor 26
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Zachary Cooper', 'Arabic', 'Auditory', 4.6, 170, 'zachary.cooper@example.com', 0.00, 'MBA', 'Programming, Algorithms', 'I am Zachary Cooper, an Auditory tutor with an MBA. I specialize in Programming and Algorithms, and I have conducted 170 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (26, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 42.00),
       (26, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (26, '2025-03-21', '09:00:00', '10:00:00'),
       (26, '2025-03-25', '11:15:00', '12:15:00'),
       (26, '2025-03-27', '14:00:00', '15:00:00'),
       (26, '2025-03-29', '15:30:00', '16:30:00');
       
-- Tutor 27
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Aaron Reed', 'English', 'Read/Write', 4.2, 130, 'aaron.reed@example.com', 0.00, 'BSc Mathematics', 'Data Structures, Machine Learning', 'I am Aaron Reed, a Read/Write tutor with a BSc in Mathematics. My expertise in Data Structures and Machine Learning is supported by 130 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (27, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 40.00),
       (27, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (27, '2025-03-21', '09:00:00', '10:00:00'),
       (27, '2025-03-30', '08:30:00', '09:30:00'),
       (27, '2025-03-23', '11:15:00', '12:15:00'),
       (27, '2025-03-25', '14:30:00', '15:30:00');

-- Tutor 28
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Bethany Cox', 'Spanish', 'Visual', 4.4, 140, 'bethany.cox@example.com', 0.00, 'BA Computer Science', 'Calculus 2, Linear Regression', 'I am Bethany Cox, a Visual tutor with a BA in Computer Science. I specialize in Calculus 2 and Linear Regression, having completed 140 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (28, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 44.00),
       (28, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (28, '2025-03-21', '09:00:00', '10:00:00'),
       (28, '2025-03-22', '10:45:00', '11:45:00'),
       (28, '2025-03-24', '12:30:00', '13:30:00'),
       (28, '2025-03-26', '15:15:00', '16:15:00');

-- Tutor 29
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Caleb Brooks', 'French', 'Auditory', 3.6, 100, 'caleb.brooks@example.com', 0.00, 'BSc Chemistry', 'Organic Chemistry, Statistics', 'I am Caleb Brooks, an Auditory tutor with a BSc in Chemistry. I focus on Organic Chemistry and Statistics with 100 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (29, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 43.00),
       (29, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (29, '2025-03-21', '09:00:00', '10:00:00'),
       (29, '2025-03-23', '10:00:00', '11:00:00'),
       (29, '2025-03-25', '11:45:00', '12:45:00'),
       (29, '2025-03-27', '14:30:00', '15:30:00');

-- Tutor 30
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Danielle Ward', 'German', 'Read/Write', 4.8, 180, 'danielle.ward@example.com', 0.00, 'MSc Computer Science', 'Programming, Calculus 2', 'I am Danielle Ward, a Read/Write tutor with an MSc in Computer Science. I excel in Programming and Calculus 2, and have completed 180 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (30, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 38.00),
       (30, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (30, '2025-03-21', '09:00:00', '10:00:00'),
       (30, '2025-03-24', '09:15:00', '10:15:00'),
       (30, '2025-03-26', '10:30:00', '11:30:00'),
       (30, '2025-03-28', '14:45:00', '15:45:00');

-- Tutor 31
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Ethan Price', 'Arabic', 'Visual', 4.0, 115, 'ethan.price@example.com', 0.00, 'BSc Engineering', 'Physics, Machine Learning', 'I am Ethan Price, a Visual tutor with a BSc in Engineering. I specialize in Physics and Machine Learning, having completed 115 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (31, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 45.00),
       (31, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 48.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (31, '2025-03-21', '09:00:00', '10:00:00'),
       (31, '2025-03-25', '09:00:00', '10:00:00'),
       (31, '2025-03-27', '11:30:00', '12:30:00'),
       (31, '2025-03-29', '15:00:00', '16:00:00');

-- Tutor 32
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Faith Long', 'English', 'Auditory', 4.9, 205, 'faith.long@example.com', 0.00, 'MSc Computer Science', 'Data Structures, Algorithms', 'I am Faith Long, an Auditory tutor with an MSc in Computer Science. I excel in Data Structures and Algorithms and have successfully completed 205 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (32, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 41.00),
       (32, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 44.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (32, '2025-03-21', '09:00:00', '10:00:00'),
       (32, '2025-03-23', '10:15:00', '11:15:00'),
       (32, '2025-03-25', '12:30:00', '13:30:00'),
       (32, '2025-03-27', '15:45:00', '16:45:00');

-- Tutor 33
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Gavin Patterson', 'Spanish', 'Read/Write', 3.5, 85, 'gavin.patterson@example.com', 0.00, 'BA Economics', 'Statistics, Programming', 'I am Gavin Patterson, a Read/Write tutor with a BA in Economics. I specialize in Statistics and Programming, with 85 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (33, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00),
       (33, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 38.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (33, '2025-03-21', '09:00:00', '10:00:00'),
       (33, '2025-03-24', '11:00:00', '12:00:00'),
       (33, '2025-03-26', '13:15:00', '14:15:00'),
       (33, '2025-03-28', '16:00:00', '17:00:00');

-- Tutor 34
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Hailey Hughes', 'French', 'Visual', 4.2, 125, 'hailey.hughes@example.com', 0.00, 'BSc Mathematics', 'Linear Regression, Organic Chemistry', 'I am Hailey Hughes, a Visual tutor with a BSc in Mathematics. I focus on Linear Regression and Organic Chemistry, and have completed 125 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (34, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 42.00),
       (34, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 44.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (34, '2025-03-21', '09:00:00', '10:00:00'),
       (34, '2025-03-30', '12:30:00', '13:30:00'),
       (34, '2025-03-23', '10:45:00', '11:45:00'),
       (34, '2025-03-25', '14:00:00', '15:00:00');

-- Tutor 35
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Kyle Bennett', 'English', 'Visual', 4.0, 120, 'kyle.bennett@example.com', 0.00, 'BA Computer Science', 'Data Structures, Algorithms', 'I am Kyle Bennett, a Visual tutor with a BA in Computer Science. My expertise in Data Structures and Algorithms is reflected in my 120 completed sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (35, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 40.00),
       (35, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (35, '2025-03-21', '09:00:00', '10:00:00'),
       (35, '2025-03-30', '13:00:00', '14:00:00'),
       (35, '2025-03-23', '14:15:00', '15:15:00'),
       (35, '2025-03-25', '15:30:00', '16:30:00');

-- Tutor 36
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Bethany Cox', 'Spanish', 'Visual', 4.4, 140, 'bethany.cox2@example.com', 0.00, 'BSc Information Systems', 'Calculus 2, Linear Regression', 'I am Bethany Cox, a Visual tutor with a BSc in Information Systems. I specialize in Calculus 2 and Linear Regression, with 140 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (36, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 44.00),
       (36, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (36, '2025-03-21', '09:00:00', '10:00:00'),
       (36, '2025-03-22', '10:15:00', '11:15:00'),
       (36, '2025-03-24', '11:45:00', '12:45:00'),
       (36, '2025-03-26', '13:30:00', '14:30:00');

-- Tutor 37
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Caleb Brooks', 'French', 'Auditory', 3.6, 100, 'caleb.brooks2@example.com', 0.00, 'BSc Chemistry', 'Organic Chemistry, Statistics', 'I am Caleb Brooks, an Auditory tutor with a BSc in Chemistry. I focus on Organic Chemistry and Statistics, with 100 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (37, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 43.00),
       (37, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (37, '2025-03-21', '09:00:00', '10:00:00'),
       (37, '2025-03-23', '10:00:00', '11:00:00'),
       (37, '2025-03-25', '11:15:00', '12:15:00'),
       (37, '2025-03-27', '14:00:00', '15:00:00');
       

-- Tutor 38
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Danielle Ward', 'German', 'Read/Write', 4.8, 180, 'danielle.ward2@example.com', 0.00, 'MSc Computer Science', 'Programming, Calculus 2', 'I am Danielle Ward, a Read/Write tutor with an MSc in Computer Science. I specialize in Programming and Calculus 2, and have successfully completed 180 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (38, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 38.00),
       (38, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (38, '2025-03-21', '09:00:00', '10:00:00'),
       (38, '2025-03-24', '09:15:00', '10:15:00'),
       (38, '2025-03-26', '10:30:00', '11:30:00'),
       (38, '2025-03-28', '14:45:00', '15:45:00');
       
-- Tutor 39
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Nora Perry', 'German', 'Visual', 4.5, 150, 'nora.perry@example.com', 0.00, 'BSc Mathematics', 'Programming, Data Structures', 'I am Nora Perry, a Visual tutor with a BSc in Mathematics. I excel in Programming and Data Structures, with 150 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (39, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 38.00),
       (39, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (39, '2025-03-21', '09:00:00', '10:00:00'),
       (39, '2025-03-22', '09:30:00', '10:30:00'),
       (39, '2025-03-24', '11:45:00', '12:45:00'),
       (39, '2025-03-26', '14:30:00', '15:30:00');
       
-- Tutor 40
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Owen Russell', 'Arabic', 'Auditory', 4.1, 110, 'owen.russell@example.com', 0.00, 'BA Engineering', 'Algorithms, Machine Learning', 'I am Owen Russell, an Auditory tutor with a BA in Engineering. I specialize in Algorithms and Machine Learning, having completed 110 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (40, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 43.00),
       (40, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (40, '2025-03-21', '09:00:00', '10:00:00'),
       (40, '2025-03-25', '10:00:00', '11:00:00'),
       (40, '2025-03-27', '11:30:00', '12:30:00'),
       (40, '2025-03-29', '15:00:00', '16:00:00');
       
-- Tutor 41
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Penelope Bryant', 'English', 'Read/Write', 4.7, 160, 'penelope.bryant@example.com', 0.00, 'MSc Mathematics', 'Calculus, Data Structures', 'I am Penelope Bryant, a Read/Write tutor with an MSc in Mathematics. I specialize in Calculus and Data Structures, with 160 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (41, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (41, '2025-03-21', '09:00:00', '10:00:00'),
       (41, '2025-03-26', '09:00:00', '10:00:00'),
       (41, '2025-03-28', '11:15:00', '12:15:00'),
       (41, '2025-03-29', '14:30:00', '15:30:00');
       
-- Tutor 42
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Queen Fisher', 'Spanish', 'Visual', 3.8, 90, 'queen.fisher@example.com', 0.00, 'BA History', 'Organic Chemistry, Physics', 'I am Queen Fisher, a Visual tutor with a BA in History. I focus on Organic Chemistry and Physics, with 90 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (42, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 44.00),
       (42, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 46.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (42, '2025-03-21', '09:00:00', '10:00:00'),
       (42, '2025-03-24', '10:15:00', '11:15:00'),
       (42, '2025-03-26', '12:30:00', '13:30:00'),
       (42, '2025-03-28', '15:00:00', '16:00:00');
       
-- Tutor 43
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Rebecca Simmons', 'French', 'Auditory', 4.6, 170, 'rebecca.simmons@example.com', 0.00, 'BSc English', 'Programming, Algorithms', 'I am Rebecca Simmons, an Auditory tutor with a BSc in English. I excel in Programming and Algorithms, having successfully completed 170 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (43, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 39.00),
       (43, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (43, '2025-03-21', '09:00:00', '10:00:00'),
       (43, '2025-03-25', '11:30:00', '12:30:00'),
       (43, '2025-03-27', '13:45:00', '14:45:00'),
       (43, '2025-03-29', '15:15:00', '16:15:00');
       
-- Tutor 44
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Samuel Butler', 'German', 'Read/Write', 4.2, 135, 'samuel.butler@example.com', 0.00, 'BSc Mathematics', 'Data Structures, Machine Learning', 'I am Samuel Butler, a Read/Write tutor with a BSc in Mathematics. I specialize in Data Structures and Machine Learning, with 135 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (44, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 40.00),
       (44, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (44, '2025-03-21', '09:00:00', '10:00:00'),
       (44, '2025-03-30', '09:15:00', '10:15:00'),
       (44, '2025-03-23', '11:00:00', '12:00:00'),
       (44, '2025-03-25', '14:00:00', '15:00:00');

-- Tutor 45
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Tina Ward', 'Arabic', 'Visual', 4.4, 140, 'tina.ward@example.com', 0.00, 'BSc Engineering', 'Calculus 2, Linear Regression', 'I am Tina Ward, a Visual tutor with a BSc in Engineering. I focus on Calculus 2 and Linear Regression, having completed 140 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (45, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 43.00),
       (45, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (45, '2025-03-21', '09:00:00', '10:00:00'),
       (45, '2025-03-22', '09:45:00', '10:45:00'),
       (45, '2025-03-24', '11:30:00', '12:30:00'),
       (45, '2025-03-26', '14:15:00', '15:15:00');
       
-- Tutor 46
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Ulysses Grant', 'English', 'Auditory', 3.6, 100, 'ulysses.grant@example.com', 0.00, 'BSc History', 'Organic Chemistry, Statistics', 'I am Ulysses Grant, an Auditory tutor with a BSc in History. I specialize in Organic Chemistry and Statistics, with 100 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (46, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), 44.00),
       (46, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (46, '2025-03-21', '09:00:00', '10:00:00'),
       (46, '2025-03-23', '12:30:00', '13:30:00'),
       (46, '2025-03-25', '14:45:00', '15:45:00'),
       (46, '2025-03-27', '16:00:00', '17:00:00');
       
-- Tutor 47
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Violet Diaz', 'Spanish', 'Read/Write', 4.8, 180, 'violet.diaz@example.com', 0.00, 'BA Art', 'Programming, Calculus 2', 'I am Violet Diaz, a Read/Write tutor with a BA in Art. I specialize in Programming and Calculus 2, with 180 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (47, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), 39.00),
       (47, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 42.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (47, '2025-03-21', '09:00:00', '10:00:00'),
       (47, '2025-03-24', '09:30:00', '10:30:00'),
       (47, '2025-03-26', '11:45:00', '12:45:00'),
       (47, '2025-03-28', '14:30:00', '15:30:00');
       
-- Tutor 48
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Wesley Ortiz', 'French', 'Visual', 4.0, 115, 'wesley.ortiz@example.com', 0.00, 'BSc Computer Science', 'Physics, Machine Learning', 'I am Wesley Ortiz, a Visual tutor with a BSc in Computer Science. I focus on Physics and Machine Learning, having completed 115 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (48, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), 45.00),
       (48, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 47.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (48, '2025-03-21', '09:00:00', '10:00:00'),
       (48, '2025-03-25', '09:15:00', '10:15:00'),
       (48, '2025-03-27', '11:30:00', '12:30:00'),
       (48, '2025-03-29', '15:00:00', '16:00:00');
       
-- Tutor 49
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Xander Mills', 'German', 'Auditory', 4.9, 205, 'xander.mills@example.com', 0.00, 'MSc Computer Science', 'Data Structures, Algorithms', 'I am Xander Mills, an Auditory tutor with an MSc in Computer Science. I specialize in Data Structures and Algorithms, with 205 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (49, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'), 42.00),
       (49, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (49, '2025-03-21', '09:00:00', '10:00:00'),
       (49, '2025-03-25', '10:30:00', '11:30:00'),
       (49, '2025-03-27', '12:00:00', '13:00:00'),
       (49, '2025-03-29', '15:15:00', '16:15:00');

-- Tutor 50
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Ethan Mitchell', 'English', 'Visual', 4.6, 150, 'ethan.mitchell@example.com', 1200.00, '["PhD in Mathematics", "5 years tutoring experience"]', 'Calculus, Differential Equations', 'I am Ethan Mitchell, a Visual tutor with a PhD in Mathematics and 5 years of tutoring experience. I specialize in Calculus and Differential Equations, and have completed 150 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (50, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 45.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (50, '2025-03-21', '09:00:00', '10:00:00'),
       (50, '2025-03-22', '10:00:00', '11:00:00'),
       (50, '2025-03-24', '12:00:00', '13:00:00'),
       (50, '2025-03-26', '14:00:00', '15:00:00');
INSERT INTO TutorReviews (tutor_id, student_name, rating, comment)
VALUES (50, 'John Doe', 5, 'Great explanations!'),
       (50, 'Emma Davis', 1, 'Very bad.');
       
-- Tutor 51
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Sophia Anderson', 'English', 'Visual', 4.7, 180, 'sophia.anderson@example.com', 1400.00, '["MSc in Applied Mathematics", "Former University Lecturer"]', 'Calculus, Algebra', 'I am Sophia Anderson, a Visual tutor with an MSc in Applied Mathematics and former university lecturer experience. I specialize in Calculus and Algebra, with 180 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (51, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (51, '2025-03-21', '09:00:00', '10:00:00'),
       (51, '2025-03-30', '09:30:00', '10:30:00'),
       (51, '2025-03-23', '11:00:00', '12:00:00'),
       (51, '2025-03-25', '14:00:00', '15:00:00');
INSERT INTO TutorReviews (tutor_id, student_name, rating, comment)
VALUES (51, 'Olivia Turner', 4.7, 'Patient and detailed explanations.');

-- Tutor 52
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Liam Carter', 'English', 'Visual', 4.8, 200, 'liam.carter@example.com', 1600.00, '["MSc in Data Science", "Google ML Certification"]', 'Machine Learning, Python, AI', 'I am Liam Carter, a Visual tutor with an MSc in Data Science and Google ML Certification. I specialize in Machine Learning, Python, and AI, and have completed 200 sessions.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (52, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), 50.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (52, '2025-03-21', '09:00:00', '10:00:00'),
       (52, '2025-03-22', '11:00:00', '12:00:00'),
       (52, '2025-03-24', '13:00:00', '14:00:00'),
       (52, '2025-03-26', '15:00:00', '16:00:00');
INSERT INTO TutorReviews (tutor_id, student_name, rating, comment)
VALUES (52, 'Jane Smith', 4.8, 'Very patient and clear.');

-- Tutor 53
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Olivia Johnson', 'English', 'Visual', 4.9, 170, 'olivia.johnson@example.com', 1800.00, '["PhD in Computer Science", "10 years experience in AI"]', 'Deep Learning, TensorFlow, CNNs', 'I am Olivia Johnson, a Visual tutor with a PhD in Computer Science and 10 years of experience in AI. I specialize in Deep Learning, TensorFlow, and CNNs, with 170 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (53, (SELECT subject_id FROM Subjects WHERE subject_name = 'Deep Learning'), 60.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (53, '2025-03-21', '09:00:00', '10:00:00'),
       (53, '2025-03-23', '12:00:00', '13:00:00'),
       (53, '2025-03-25', '09:30:00', '10:30:00'),
       (53, '2025-03-27', '14:15:00', '15:15:00');
INSERT INTO TutorReviews (tutor_id, student_name, rating, comment)
VALUES (53, 'David Brown', 4.7, 'Super knowledgeable about ML models.');

-- Tutor 54
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Noah Williams', 'English', 'Visual', 2.0, 190, 'noah.williams@example.com', 1500.00, '["BSc in Computer Science", "Competitive Programming Coach"]', 'Data Structures, Algorithms, Java', 'I am Noah Williams, a Visual tutor with a BSc in Computer Science and experience as a competitive programming coach. I specialize in Data Structures, Algorithms, and Java, with 190 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (54, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures and Algorithms'), 55.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (54, '2025-03-21', '09:00:00', '10:00:00'),
       (54, '2025-03-24', '10:00:00', '11:00:00'),
       (54, '2025-03-26', '11:30:00', '12:30:00'),
       (54, '2025-03-29', '09:30:00', '10:30:00');
INSERT INTO TutorReviews (tutor_id, student_name, rating, comment)
VALUES (54, 'Lucas Wright', 4.7, 'Amazing teaching methods for deep learning.');

-- Tutor 55
INSERT INTO Tutors (name, preferred_language, teaching_style, average_star_rating, completed_sessions, email, earnings, qualifications, expertise, bio)
VALUES 
('Bethany Cox', 'Spanish', 'Visual', 4.4, 140, 'bethany.cox3@example.com', 0.00, 'BA Computer Science', 'Calculus, Data Structures', 'I am Bethany Cox, a Visual tutor with a BA in Computer Science. I specialize in Calculus and Data Structures, with 140 sessions completed.');
INSERT INTO TutorSubjects (tutor_id, subject_id, price)
VALUES (55, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), 44.00),
       (55, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), 40.00);
INSERT INTO TutorAvailableSlots (tutor_id, available_date, start_time, end_time)
VALUES (55, '2025-03-21', '09:00:00', '10:00:00'),
       (55, '2025-03-30', '08:45:00', '09:45:00'),
       (55, '2025-03-23', '10:30:00', '11:30:00'),
       (55, '2025-03-25', '13:15:00', '14:15:00');
	
-- ============================================================
-- INSERT STUDENT DATA, STUDENT SUBJECTS, and STUDENT AVAILABLE SLOTS
-- ============================================================
-- Student 1
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Adam Freeman', 'Visual', 'English', 300.00, 'password', 'adam.freeman@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2')),
       (1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (1, '2025-03-21', '09:00:00', '10:00:00'),
       (1, '2025-03-30', '08:20:00', '09:20:00'),
       (1, '2025-03-24', '10:15:00', '11:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (1, 'Calculus 1', 1);

-- Student 2
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Bella Knight', 'Auditory', 'Spanish', 450.00, 'password', 'bella.knight@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (2, '2025-03-21', '09:00:00', '10:00:00'),
       (2, '2025-03-22', '09:35:00', '10:35:00'),
       (2, '2025-03-25', '11:00:00', '12:00:00');

-- Student 3
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Cody Long', 'Visual', 'French', 500.00, 'password', 'cody.long@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (3, '2025-03-21', '09:00:00', '10:00:00'),
       (3, '2025-03-23', '10:50:00', '11:50:00'),
       (3, '2025-03-26', '14:20:00', '15:20:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (3, 'Basic Chemistry', 1);

-- Student 4
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Daisy Rivera', 'Read/Write', 'German', 350.00, 'password', 'daisy.rivera@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression')),
       (4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (4, '2025-03-21', '09:00:00', '10:00:00'),
       (4, '2025-03-24', '11:10:00', '12:10:00'),
       (4, '2025-03-27', '14:00:00', '15:00:00');

-- Student 5
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Evan Stone', 'Auditory', 'Arabic', 600.00, 'password', 'evan.stone@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning')),
       (5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (5, '2025-03-21', '09:00:00', '10:00:00'),
       (5, '2025-03-25', '13:20:00', '14:20:00'),
       (5, '2025-03-28', '15:00:00', '16:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (5, 'Data Structures', 1);

-- Student 6
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Faye Murphy', 'Visual', 'English', 275.00, 'password', 'faye.murphy@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (6, '2025-03-21', '09:00:00', '10:00:00'),
       (6, '2025-03-30', '09:55:00', '10:55:00'),
       (6, '2025-03-24', '10:15:00', '11:15:00');

-- Student 7
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Gavin Ross', 'Read/Write', 'Spanish', 320.00, 'password', 'gavin.ross@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics')),
       (7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (7, '2025-03-21', '09:00:00', '10:00:00'),
       (7, '2025-03-22', '10:50:00', '11:50:00'),
       (7, '2025-03-25', '11:10:00', '12:10:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (7, 'Basic Chemistry', 1);

-- Student 8
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Hazel Ford', 'Auditory', 'French', 400.00, 'password', 'hazel.ford@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1')),
       (8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (8, '2025-03-21', '09:00:00', '10:00:00'),
       (8, '2025-03-23', '10:05:00', '11:05:00'),
       (8, '2025-03-26', '11:50:00', '12:50:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (8, 'Algebra', 1);

-- Student 9
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Isaiah Wood', 'Visual', 'German', 550.00, 'password', 'isaiah.wood@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (9, '2025-03-21', '09:00:00', '10:00:00'),
       (9, '2025-03-24', '15:05:00', '16:05:00'),
       (9, '2025-03-27', '10:15:00', '11:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (9, 'Data Structures', 1);

-- Student 10
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Jasmine Bell', 'Read/Write', 'Arabic', 480.00, 'password', 'jasmine.bell@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics')),
       (10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (10, '2025-03-21', '09:00:00', '10:00:00'),
       (10, '2025-03-25', '09:10:00', '10:10:00'),
       (10, '2025-03-27', '11:00:00', '12:00:00');

-- Student 11
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Kyle Brooks', 'Auditory', 'English', 390.00, 'password', 'kyle.brooks@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (11, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (11, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (11, '2025-03-21', '09:00:00', '10:00:00'),
       (11, '2025-03-30', '11:10:00', '12:10:00'),
       (11, '2025-03-24', '12:30:00', '13:30:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (11, 'Basic Chemistry', 1);

-- Student 12
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Lola Hayes', 'Visual', 'Spanish', 310.00, 'password', 'lola.hayes@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (12, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2')),
       (12, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (12, '2025-03-21', '09:00:00', '10:00:00'),
       (12, '2025-03-22', '10:50:00', '11:50:00'),
       (12, '2025-03-26', '11:15:00', '12:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (12, 'Calculus 1', 1);

-- Student 13
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Mason Reed', 'Read/Write', 'French', 525.00, 'password', 'mason.reed@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (13, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (13, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (13, '2025-03-21', '09:00:00', '10:00:00'),
       (13, '2025-03-23', '12:05:00', '13:05:00'),
       (13, '2025-03-27', '14:30:00', '15:30:00');

-- Student 14
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Nina Foster', 'Auditory', 'German', 430.00, 'password', 'nina.foster@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (14, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning')),
       (14, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (14, '2025-03-21', '09:00:00', '10:00:00'),
       (14, '2025-03-24', '12:25:00', '13:25:00'),
       (14, '2025-03-27', '14:45:00', '15:45:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (14, 'Data Structures', 1);

-- Student 15
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Owen Price', 'Visual', 'Arabic', 365.00, 'password', 'owen.price@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (15, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression')),
       (15, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (15, '2025-03-21', '09:00:00', '10:00:00'),
       (15, '2025-03-25', '10:00:00', '11:00:00'),
       (15, '2025-03-27', '11:30:00', '12:30:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (15, 'Basic Chemistry', 1);

-- Student 16
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Paige Hunter', 'Read/Write', 'English', 295.00, 'password', 'paige.hunter@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (16, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (16, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (16, '2025-03-21', '09:00:00', '10:00:00'),
       (16, '2025-03-30', '11:10:00', '12:10:00'),
       (16, '2025-03-24', '12:45:00', '13:45:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (16, 'Calculus 1', 1);

-- Student 17
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Quinn Martin', 'Auditory', 'Spanish', 410.00, 'password', 'quinn.martin@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (17, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics')),
       (17, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (17, '2025-03-21', '09:00:00', '10:00:00'),
       (17, '2025-03-22', '14:05:00', '15:05:00'),
       (17, '2025-03-25', '11:30:00', '12:30:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (17, 'Calculus 2', 1);

-- Student 18
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Riley Diaz', 'Visual', 'French', 520.00, 'password', 'riley.diaz@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (18, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (18, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (18, '2025-03-21', '09:00:00', '10:00:00'),
       (18, '2025-03-23', '16:20:00', '17:20:00'),
       (18, '2025-03-26', '10:05:00', '11:05:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (18, 'Data Structures', 1);

-- Student 19
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Sophia Carter', 'Read/Write', 'German', 350.00, 'password', 'sophia.carter@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (19, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (19, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (19, '2025-03-21', '09:00:00', '10:00:00'),
       (19, '2025-03-24', '09:35:00', '10:35:00'),
       (19, '2025-03-27', '11:00:00', '12:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (19, 'Basic Chemistry', 1);

-- Student 20
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Tyler Reed', 'Auditory', 'Arabic', 380.00, 'password', 'tyler.reed@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (20, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1')),
       (20, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (20, '2025-03-21', '09:00:00', '10:00:00'),
       (20, '2025-03-25', '12:35:00', '13:35:00'),
       (20, '2025-03-27', '11:10:00', '12:10:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (20, 'Algebra', 1);

-- Student 21
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Uma Stevens', 'Visual', 'English', 465.00, 'password', 'uma.stevens@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (21, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (21, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (21, '2025-03-21', '09:00:00', '10:00:00'),
       (21, '2025-03-30', '10:05:00', '11:05:00'),
       (21, '2025-03-24', '11:45:00', '12:45:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (21, 'Data Structures', 1);

-- Student 22
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Victor Chavez', 'Read/Write', 'Spanish', 540.00, 'password', 'victor.chavez@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (22, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (22, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (22, '2025-03-21', '09:00:00', '10:00:00'),
       (22, '2025-03-22', '10:50:00', '11:50:00'),
       (22, '2025-03-26', '11:15:00', '12:15:00');

-- Student 23
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Wendy Rivera', 'Auditory', 'French', 330.00, 'password', 'wendy.rivera@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (23, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (23, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (23, '2025-03-21', '09:00:00', '10:00:00'),
       (23, '2025-03-23', '13:50:00', '14:50:00'),
       (23, '2025-03-26', '10:05:00', '11:05:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (23, 'Basic Chemistry', 1);

-- Student 24
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Xavier Ortiz', 'Visual', 'German', 475.00, 'password', 'xavier.ortiz@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (24, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2')),
       (24, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (24, '2025-03-21', '09:00:00', '10:00:00'),
       (24, '2025-03-24', '10:30:00', '11:30:00'),
       (24, '2025-03-27', '11:15:00', '12:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (24, 'Calculus 1', 1);

-- Student 25
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Yara Morales', 'Read/Write', 'Arabic', 520.00, 'password', 'yara.morales@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (25, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning')),
       (25, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (25, '2025-03-21', '09:00:00', '10:00:00'),
       (25, '2025-03-25', '11:15:00', '12:15:00'),
       (25, '2025-03-27', '12:30:00', '13:30:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (25, 'Data Structures', 1);

-- Student 26
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Zack Henderson', 'Auditory', 'English', 400.00, 'password', 'zack.henderson@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (26, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms')),
       (26, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (26, '2025-03-21', '09:00:00', '10:00:00'),
       (26, '2025-03-30', '15:05:00', '16:05:00'),
       (26, '2025-03-24', '10:50:00', '11:50:00');

-- Student 27
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Abby Powell', 'Visual', 'Spanish', 360.00, 'password', 'abby.powell@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (27, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (27, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (27, '2025-03-21', '09:00:00', '10:00:00'),
       (27, '2025-03-22', '12:05:00', '13:05:00'),
       (27, '2025-03-25', '11:10:00', '12:10:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (27, 'Basic Chemistry', 1);

-- Student 28
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Blake Jenkins', 'Read/Write', 'French', 495.00, 'password', 'blake.jenkins@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (28, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (28, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (28, '2025-03-21', '09:00:00', '10:00:00'),
       (28, '2025-03-23', '10:05:00', '11:05:00'),
       (28, '2025-03-26', '11:30:00', '12:30:00');

-- Student 29
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Casey Riley', 'Auditory', 'German', 415.00, 'password', 'casey.riley@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (29, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics')),
       (29, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (29, '2025-03-21', '09:00:00', '10:00:00'),
       (29, '2025-03-24', '14:30:00', '15:30:00'),
       (29, '2025-03-27', '10:50:00', '11:50:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (29, 'Calculus 2', 1);

-- Student 30
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Derek Alexander', 'Visual', 'Arabic', 385.00, 'password', 'derek.alexander@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (30, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression')),
       (30, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (30, '2025-03-21', '09:00:00', '10:00:00'),
       (30, '2025-03-25', '09:40:00', '10:40:00'),
       (30, '2025-03-27', '11:15:00', '12:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (30, 'Algebra', 1);

-- Student 31
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Elena Torres', 'Read/Write', 'English', 430.00, 'password', 'elena.torres@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (31, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (31, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (31, '2025-03-21', '09:00:00', '10:00:00'),
       (31, '2025-03-30', '11:10:00', '12:10:00'),
       (31, '2025-03-24', '12:30:00', '13:30:00');

-- Student 32
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Felix Burns', 'Auditory', 'Spanish', 375.00, 'password', 'felix.burns@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (32, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (32, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (32, '2025-03-21', '09:00:00', '10:00:00'),
       (32, '2025-03-22', '10:50:00', '11:50:00'),
       (32, '2025-03-26', '11:15:00', '12:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (32, 'Basic Chemistry', 1);

-- Student 33
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Gia Freeman', 'Visual', 'French', 455.00, 'password', 'gia.freeman@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (33, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1')),
       (33, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (33, '2025-03-21', '09:00:00', '10:00:00'),
       (33, '2025-03-23', '09:35:00', '10:35:00'),
       (33, '2025-03-26', '11:00:00', '12:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (33, 'Algebra', 1);

-- Student 34
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Hector Arnold', 'Read/Write', 'German', 490.00, 'password', 'hector.arnold@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (34, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (34, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (34, '2025-03-21', '09:00:00', '10:00:00'),
       (34, '2025-03-24', '12:45:00', '13:45:00'),
       (34, '2025-03-27', '14:00:00', '15:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (34, 'Data Structures', 1);

-- Student 35
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Ivy Goodman', 'Auditory', 'Arabic', 520.00, 'password', 'ivy.goodman@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (35, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (35, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (35, '2025-03-21', '09:00:00', '10:00:00'),
       (35, '2025-03-22', '10:20:00', '11:20:00'),
       (35, '2025-03-25', '11:45:00', '12:45:00');

-- Student 36
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Jonas Klein', 'Visual', 'English', 360.00, 'password', 'jonas.klein@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (36, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (36, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (36, '2025-03-21', '09:00:00', '10:00:00'),
       (36, '2025-03-30', '12:35:00', '13:35:00'),
       (36, '2025-03-24', '10:50:00', '11:50:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (36, 'Basic Chemistry', 1);

-- Student 37
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Kira Lane', 'Read/Write', 'Spanish', 410.00, 'password', 'kira.lane@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (37, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2')),
       (37, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (37, '2025-03-21', '09:00:00', '10:00:00'),
       (37, '2025-03-22', '09:35:00', '10:35:00'),
       (37, '2025-03-25', '11:10:00', '12:10:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (37, 'Calculus 1', 1);

-- Student 38
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Liam Fox', 'Auditory', 'French', 535.00, 'password', 'liam.fox@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (38, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning')),
       (38, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (38, '2025-03-21', '09:00:00', '10:00:00'),
       (38, '2025-03-23', '14:20:00', '15:20:00'),
       (38, '2025-03-26', '10:05:00', '11:05:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (38, 'Data Structures', 1);

-- Student 39
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Mia Summers', 'Visual', 'German', 440.00, 'password', 'mia.summers@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (39, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms')),
       (39, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (39, '2025-03-21', '09:00:00', '10:00:00'),
       (39, '2025-03-24', '11:30:00', '12:30:00'),
       (39, '2025-03-27', '13:15:00', '14:15:00');

-- Student 40
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Noah Waters', 'Read/Write', 'Arabic', 375.00, 'password', 'noah.waters@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (40, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (40, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (40, '2025-03-21', '09:00:00', '10:00:00'),
       (40, '2025-03-25', '13:00:00', '14:00:00'),
       (40, '2025-03-27', '10:15:00', '11:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (40, 'Basic Chemistry', 1);

-- Student 41
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Olivia West', 'Auditory', 'English', 465.00, 'password', 'olivia.west@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (41, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (41, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (41, '2025-03-21', '09:00:00', '10:00:00'),
       (41, '2025-03-30', '10:05:00', '11:05:00'),
       (41, '2025-03-24', '11:45:00', '12:45:00');

-- Student 42
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Paul Douglas', 'Visual', 'Spanish', 420.00, 'password', 'paul.douglas@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (42, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics')),
       (42, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (42, '2025-03-21', '09:00:00', '10:00:00'),
       (42, '2025-03-22', '14:05:00', '15:05:00'),
       (42, '2025-03-26', '11:15:00', '12:15:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (42, 'Calculus', 1);

-- Student 43
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Queenie Burns', 'Read/Write', 'French', 535.00, 'password', 'queenie.burns@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (43, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (43, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (43, '2025-03-21', '09:00:00', '10:00:00'),
       (43, '2025-03-23', '11:10:00', '12:10:00'),
       (43, '2025-03-26', '13:30:00', '14:30:00');

-- Student 44
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Rachel Adams', 'Auditory', 'English', 360.00, 'password', 'rachel.adams@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (44, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry')),
       (44, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (44, '2025-03-21', '09:00:00', '10:00:00'),
       (44, '2025-03-24', '09:05:00', '10:05:00'),
       (44, '2025-03-27', '11:00:00', '12:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (44, 'Basic Chemistry', 1);

-- Student 45
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Steven Clark', 'Read/Write', 'Spanish', 410.00, 'password', 'steven.clark@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (45, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming')),
       (45, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (45, '2025-03-21', '09:00:00', '10:00:00'),
       (45, '2025-03-25', '10:05:00', '11:05:00'),
       (45, '2025-03-27', '11:45:00', '12:45:00');

-- Student 46
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Tara Lewis', 'Visual', 'French', 395.00, 'password', 'tara.lewis@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (46, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2')),
       (46, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (46, '2025-03-21', '09:00:00', '10:00:00'),
       (46, '2025-03-26', '11:20:00', '12:20:00'),
       (46, '2025-03-28', '14:00:00', '15:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (46, 'Calculus 1', 1);

-- Student 47
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Uma Patel', 'Auditory', 'German', 425.00, 'password', 'uma.patel@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (47, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning')),
       (47, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (47, '2025-03-21', '09:00:00', '10:00:00'),
       (47, '2025-03-27', '12:10:00', '13:10:00'),
       (47, '2025-03-29', '15:00:00', '16:00:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (47, 'Data Structures', 1);

-- Student 48
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Victor King', 'Read/Write', 'Arabic', 390.00, 'password', 'victor.king@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (48, (SELECT subject_id FROM Subjects WHERE subject_name = 'Data Structures')),
       (48, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (48, '2025-03-21', '09:00:00', '10:00:00'),
       (48, '2025-03-28', '09:40:00', '10:40:00'),
       (48, '2025-03-31', '11:00:00', '12:00:00');

-- Student 49
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Wendy Scott', 'Visual', 'English', 370.00, 'password', 'wendy.scott@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (49, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics')),
       (49, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (49, '2025-03-21', '09:00:00', '10:00:00'),
       (49, '2025-03-29', '10:05:00', '11:05:00'),
       (49, '2025-03-31', '12:30:00', '13:30:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (49, 'Basic Chemistry', 1);

-- Student 50
INSERT INTO Students (name, preferred_learning_style, preferred_language, budget, password, email)
VALUES ('Xavier Young', 'Auditory', 'Spanish', 405.00, 'password', 'xavier.young@example.com');
INSERT INTO StudentSubjects (student_id, subject_id)
VALUES (50, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 1')),
       (50, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'));
INSERT INTO StudentAvailableSlots (student_id, available_date, start_time, end_time)
VALUES (50, '2025-03-21', '09:00:00', '10:00:00'),
       (50, '2025-03-25', '11:20:00', '12:20:00'),
       (50, '2025-03-27', '13:10:00', '14:10:00');
INSERT INTO StudentLearningPaths (student_id, learning_item, step_order)
VALUES (50, 'Algebra', 1);

-- ============================================================
-- INSERT SESSIONS and SESSIONFEEDBACK
-- ============================================================
-- Group A: Completed Sessions in the past (2023-08-01)
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (1, 1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), '2023-08-01 08:30:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (1, 'Very informative session in the past.', 5, 'Positive', '', 'Well done.');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (2, 2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), '2023-08-01 09:45:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (2, 'Good explanation, a bit rushed.', 4, 'Neutral', '', 'Consider slowing down.');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (3, 3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), '2023-08-01 11:00:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (3, 'Excellent clarity and depth.', 5, 'Positive', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (4, 4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), '2023-08-01 12:15:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (4, 'Informative session.', 4, 'Positive', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (5, 5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), '2023-08-01 13:30:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (5, 'I learned a lot from this session.', 5, 'Positive', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (5,7,(SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'),'2023-09-20 14:00:00','Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (LAST_INSERT_ID(), 'The session was extremely engaging and clarified many concepts in statistics.', 5, 'Positive', '', 'Keep up the excellent teaching methods!');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (6, 6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), '2023-08-01 14:45:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (6, 'Average session, could improve.', 3, 'Neutral', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (7, 7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), '2023-08-01 15:00:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (7, 'Well explained, very useful.', 5, 'Positive', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (8, 8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), '2023-08-01 16:15:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (8, 'Interactive and engaging.', 5, 'Positive', '', '');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (9, 9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), '2023-08-01 17:30:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (9, 'A bit too fast.', 3, 'Neutral', 'pace', 'Slow down next time.');

INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (10, 10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Deep Learning'), '2023-08-01 08:00:00', 'Completed');
INSERT INTO SessionFeedback (session_id, student_feedback, star_rating, feedback_sentiment, feedback_issues, improvement_tip)
VALUES (10, 'Outstanding session in the past.', 5, 'Positive', '', '');

-- Group B: Scheduled Sessions (Future – 2025-03-21, using the reserved booking slot 09:00-10:00)
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (1, 1, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (2, 2, (SELECT subject_id FROM Subjects WHERE subject_name = 'Physics'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (3, 3, (SELECT subject_id FROM Subjects WHERE subject_name = 'Programming'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (4, 4, (SELECT subject_id FROM Subjects WHERE subject_name = 'Algorithms'), '2025-03-21 09:00:00', 'Scheduled');
-- For demonstration, one scheduled session is canceled so its slot remains.
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (5, 5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), '2025-03-21 09:00:00', 'Canceled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (5, 5, (SELECT subject_id FROM Subjects WHERE subject_name = 'Statistics'), '2025-03-24 14:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (6, 6, (SELECT subject_id FROM Subjects WHERE subject_name = 'Linear Regression'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (7, 7, (SELECT subject_id FROM Subjects WHERE subject_name = 'Calculus 2'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (8, 8, (SELECT subject_id FROM Subjects WHERE subject_name = 'Machine Learning'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (9, 9, (SELECT subject_id FROM Subjects WHERE subject_name = 'Organic Chemistry'), '2025-03-21 09:00:00', 'Scheduled');
INSERT INTO Sessions (student_id, tutor_id, subject_id, scheduled_time, session_status)
VALUES (10, 10, (SELECT subject_id FROM Subjects WHERE subject_name = 'Deep Learning'), '2025-03-21 09:00:00', 'Scheduled');

SELECT * FROM SessionFeedback;


-- TRIGGERS: ENFORCE SESSION TIME CONSISTENCY AND REMOVE BOOKED SLOT
DELIMITER $$

CREATE TRIGGER before_session_insert
BEFORE INSERT ON Sessions
FOR EACH ROW
BEGIN
    DECLARE tutor_slot_count INT;
    DECLARE student_slot_count INT;
    
    IF DATE(NEW.scheduled_time) >= '2025-03-30' THEN
      SELECT COUNT(*) INTO tutor_slot_count
      FROM TutorAvailableSlots
      WHERE tutor_id = NEW.tutor_id
        AND available_date = DATE(NEW.scheduled_time)
        AND start_time = TIME(NEW.scheduled_time)
        AND end_time = TIME(DATE_ADD(NEW.scheduled_time, INTERVAL 1 HOUR));
      IF tutor_slot_count = 0 THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tutor not available at the scheduled time';
      END IF;
      
      SELECT COUNT(*) INTO student_slot_count
      FROM StudentAvailableSlots
      WHERE student_id = NEW.student_id
        AND available_date = DATE(NEW.scheduled_time)
        AND start_time = TIME(NEW.scheduled_time)
        AND end_time = TIME(DATE_ADD(NEW.scheduled_time, INTERVAL 1 HOUR));
      IF student_slot_count = 0 THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student not available at the scheduled time';
      END IF;
    END IF;
END$$

CREATE TRIGGER after_session_insert
AFTER INSERT ON Sessions
FOR EACH ROW
BEGIN
    IF DATE(NEW.scheduled_time) >= '2025-03-30' AND NEW.session_status <> 'Canceled' THEN
      DELETE FROM TutorAvailableSlots
      WHERE tutor_id = NEW.tutor_id
        AND available_date = DATE(NEW.scheduled_time)
        AND start_time = TIME(NEW.scheduled_time)
        AND end_time = TIME(DATE_ADD(NEW.scheduled_time, INTERVAL 1 HOUR));
      DELETE FROM StudentAvailableSlots
      WHERE student_id = NEW.student_id
        AND available_date = DATE(NEW.scheduled_time)
        AND start_time = TIME(NEW.scheduled_time)
        AND end_time = TIME(DATE_ADD(NEW.scheduled_time, INTERVAL 1 HOUR));
    END IF;
END$$

DELIMITER ;


