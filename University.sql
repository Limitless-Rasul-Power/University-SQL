CREATE DATABASE University;

USE University;

CREATE TABLE Departments
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL UNIQUE,
		Capacity SMALLINT NOT NULL CHECK(Capacity > 0)
);

CREATE TABLE Branches
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL UNIQUE,
		DepartmentID INT,
		FOREIGN KEY(DepartmentID) REFERENCES Departments(ID) ON DELETE CASCADE
);

CREATE TABLE Faculties
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Groups
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL UNIQUE,
		Capacity TINYINT NOT NULL,
		FacultyID INT,
		FOREIGN KEY(FacultyID) REFERENCES Faculties(ID) ON DELETE CASCADE
);

CREATE TABLE Lessons
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL UNIQUE,
		Difficulty NVARCHAR(255) NOT NULL CHECK(Difficulty = 'Easy' OR Difficulty = 'Normal' OR Difficulty = 'Hard')
);

CREATE TABLE Teachers
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		FullName NVARCHAR(255) NOT NULL,
		Birthdate DATE NOT NULL,
		ExperienceYear NUMERIC(3,1) NOT NULL CHECK(ExperienceYear > 0),
		Salary MONEY NOT NULL CHECK(Salary > 300),
		[Subject] NVARCHAR(255) NOT NULL,
		BranchID INT,
		LessonID INT,
		FOREIGN KEY(BranchID) REFERENCES Branches(ID) ON DELETE CASCADE,	
		FOREIGN KEY(LessonID) REFERENCES Lessons(ID) ON DELETE SET DEFAULT
);

CREATE TABLE Students
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		FullName NVARCHAR(255) NOT NULL,
		AverageScore NUMERIC(3,1) NOT NULL CHECK(AverageScore >= 0 AND AverageScore <= 10),
		GroupID INT,
		FOREIGN KEY(GroupID) REFERENCES Groups(ID) ON DELETE CASCADE
);

CREATE TABLE TuitionFees
(
		ID INT UNIQUE NOT NULL,
		Fee MONEY NOT NULL,
		FOREIGN KEY(ID) REFERENCES Students(ID) ON DELETE CASCADE
);

CREATE TABLE Rooms
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		Number NVARCHAR(255) NOT NULL UNIQUE,
		Capacity TINYINT NOT NULL CHECK(Capacity > 0)
);

CREATE TABLE LessonSchedules
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[DayOfWeek] NVARCHAR(255) NOT NULL,
		StartTime TIME NOT NULL,
		Duration TINYINT NOT NULL,
		RoomID INT,
		LessonID INT,
		FOREIGN KEY(RoomID) REFERENCES Rooms(ID) ON DELETE CASCADE,
		FOREIGN KEY(LessonID) REFERENCES Lessons(ID) ON DELETE CASCADE,
		UNIQUE([DayOfWeek], StartTime, RoomID)
);

CREATE TABLE Workers
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Name] NVARCHAR(255) NOT NULL,
		Salary MONEY NOT NULL CHECK(Salary > 300),
		DepartmentID INT,
		FOREIGN KEY(DepartmentID) REFERENCES Departments(ID) ON DELETE CASCADE
);

CREATE TABLE Teachers_Groups
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		TeacherID INT,
		GroupID INT,
		FOREIGN KEY(TeacherID) REFERENCES Teachers(ID) ON DELETE SET DEFAULT,
		FOREIGN KEY(GroupID) REFERENCES Groups(ID) ON DELETE CASCADE,
		UNIQUE(TeacherID, GroupID)
);

CREATE TABLE LessonSchedules_Groups
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		LessonScheduleID INT,
		GroupID INT,
		FOREIGN KEY(LessonScheduleID) REFERENCES LessonSchedules(ID) ON DELETE CASCADE,
		FOREIGN KEY(GroupID) REFERENCES Groups(ID) ON DELETE CASCADE,
		UNIQUE(LessonScheduleID, GroupID)
);

CREATE TABLE PaymentSchedules
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Date] DATETIME NOT NULL,
		Payment MONEY NOT NULL CHECK(Payment > 0)
);

CREATE TABLE Teachers_PaymentSchedules
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		TeacherID INT,
		PaymentScheduleID INT,
		FOREIGN KEY(TeacherID) REFERENCES Teachers(ID) ON DELETE NO ACTION,
		FOREIGN KEY(PaymentScheduleID) REFERENCES PaymentSchedules(ID) ON DELETE CASCADE,
		UNIQUE(TeacherID, PaymentScheduleID)
);

CREATE TABLE Students_PaymentSchedules
(
		ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		StudentID INT,
		PaymentScheduleID INT,
		FOREIGN KEY(StudentID) REFERENCES Students(ID) ON DELETE NO ACTION,
		FOREIGN KEY(PaymentScheduleID) REFERENCES PaymentSchedules(ID) ON DELETE CASCADE,
		UNIQUE(StudentID, PaymentScheduleID)
);



INSERT INTO Departments([Name], Capacity)
VALUES ('Technology', 1000), ('Accounting', 900);


INSERT INTO Branches([Name], DepartmentID)
VALUES ('Programming', 1), ('IT', 1), ('Financial Accouting', 2), ('Tax Accouting', 2);


INSERT INTO Faculties([Name])
VALUES ('Computer Engineering'), ('Test Driven Development'), ('Economics'), ('Inflation Control')


INSERT INTO Groups([Name], Capacity, FacultyID)
VALUES ('STTA_2920', 30, 1), ('ADI_74', 13, 3)



INSERT INTO Lessons([Name], Difficulty)
VALUES ('C++', 'Hard'), ('C#', 'Normal'), ('Liabilities and Assets', 'Easy'), ('Tax History', 'Hard'), ('Java', 'Hard')



INSERT INTO Teachers(FullName, Birthdate, ExperienceYear, Salary, [Subject], BranchID, LessonID)
VALUES ('Robert C.Martin', '1952-12-05', 40, 1000000, 'Clean Code', 1, 5), 
	   ('Martin Fowler', '1963-12-18', 35, 500000, 'Software Development', 1, 2),
	   ('Robert Kiyosaki', '1947-04-08', 45, 99999999, 'Rich Dad and Poor Dad', 3, 3),
	   ('Warren Buffett', '1930-08-30', 50, 9999999999, 'Investing intelligently', 4, 4)


INSERT INTO Students(FullName, AverageScore, GroupID)
VALUES ('Ricky Johnson', 7.2, 1), ('Marc Leo', 3.7, 1), ('Edward Buuren', 8.7, 1),
	   ('Susan Clark', 6.6, 2), ('James Thompson', 7.8, 2), ('William Watson', 9, 2)


INSERT INTO TuitionFees(ID, Fee)
VALUES (1, 2500), (2, 3000), (3, 2000),
	   (4, 5000), (5, 4000), (6, 3000)


INSERT INTO Rooms(Number, Capacity)
VALUES (23, 30), (33, 20), (43, 25), (78, 100), (67, 25), (90, 20), (110, 100)


INSERT INTO LessonSchedules([DayOfWeek], StartTime, Duration, RoomID, LessonID)
VALUES ('Monday', '10:00', 2, 1, 1),
	   ('Tuesday', '12:00', 3, 4, 4),
	   ('Wednesday', '17:00', 2, 2, 5),
	   ('Thursday', '15:00', 3, 7, 3),
	   ('Friday', '14:00', 2, 6, 2)


INSERT INTO Workers([Name], Salary, DepartmentID)
VALUES ('Aftandil', 400, 2), ('Israfil', 500, 1), ('Mezahir', 900, 2), ('Tukezban', 1000, 1), ('Besir', 333, 2)


INSERT INTO Teachers_Groups(TeacherID, GroupID)
VALUES (1, 1), (2, 1), (2, 2), (3, 1), (4, 1), (4, 2)


INSERT INTO LessonSchedules_Groups(LessonScheduleID, GroupID)
VALUES (1, 1), (2, 1), (2, 2), (3, 2), (4, 1), (4, 2), (5, 1)

INSERT INTO PaymentSchedules([Date], Payment)
VALUES ('2021-05-05 17:33', 200), ('2021-05-05 17:33', 1000), (GETDATE(), 2000), (GETDATE(), 5000), ('2021-03-03 15:00:32.345', 2500)

INSERT INTO Teachers_PaymentSchedules(TeacherID, PaymentScheduleID)
VALUES (2, 1)

INSERT INTO Students_PaymentSchedules(StudentID, PaymentScheduleID)
VALUES (1, 5), (3, 3), (4, 4), (6, 2)

SELECT * FROM Departments;
SELECT * FROM Branches;
SELECT * FROM Faculties;
SELECT * FROM Teachers;
SELECT * FROM Groups;
SELECT * FROM LessonSchedules;
SELECT * FROM Lessons;
SELECT * FROM Students;
SELECT * FROM TuitionFees;
SELECT * FROM PaymentSchedules;
SELECT * FROM Rooms;
SELECT * FROM Workers;
SELECT * FROM Teachers_Groups;
SELECT * FROM LessonSchedules_Groups;
SELECT * FROM Teachers_PaymentSchedules;
SELECT * FROM Students_PaymentSchedules;