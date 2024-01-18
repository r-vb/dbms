UNIVERSITY:

Create Table Student(
			sid VARCHAR(20) NOT NULL,
			Name VARCHAR(20) NOT NULL,
			Program VARCHAR(20) NOT NULL,
		        Primary Key(sid)
		     );

Create Table Course(
			course_no VARCHAR(10) NOT NULL,
			credits INT NOT NULL,
			TITLE VARCHAR(20) NOT NULL,
			Syllabus VARCHAR(20),
			Pcourse VARCHAR(20),
		        PRIMARY KEY(course_no)
		    );

Create Table Instructor(
			 iid VARCHAR(10) NOT NULL,
			 NAME VARCHAR(20) NOT NULL,
			 DEPT VARCHAR(10) NOT NULL,
			 TITLE VARCHAR(20) NOT NULL,
			 PRIMARY KEY(iid)
			);

Create Table Course_offerings(
				Room VARCHAR(5) NOT NULL,
				Year VARCHAR(10) NOT NULL,
				SEM VARCHAR(20) NOT NULL,
				course_no VARCHAR(10) NOT NULL,
				PRIMARY KEY(Year,SEM,course_no),
				FOREIGN KEY(course_no) REFERENCES Course(Course_no) ON DELETE SET NULL
			);



CREATE TABLE teaches (
    iid VARCHAR(10) NOT NULL, 
    Year VARCHAR(10) NOT NULL,
    SEM VARCHAR(20) NOT NULL, 
    course_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (iid, Year, SEM, course_no),
    FOREIGN KEY (iid) REFERENCES Instructor(iid) ON DELETE SET NULL,
    FOREIGN KEY (Year, SEM, course_no) REFERENCES Course_offerings(Year, SEM, course_no) ON DELETE SET NULL
);

Create Table enrolls(
			sid VARCHAR(20) NOT NULL,
			Year VARCHAR(10) NOT NULL,
    			SEM VARCHAR(20) NOT NULL, 
			course_no VARCHAR(10) NOT NULL,
			GRADE VARCHAR(5),
			PRIMARY KEY(sid, Year, SEM, course_no),
			FOREIGN KEY (Year, SEM, course_no) REFERENCES Course_offerings(Year, SEM, course_no) ON DELETE SET NULL,
			FOREIGN KEY (sid) REFERENCES Student(sid) ON DELETE SET NULL
		     );

INSERTION VALUES:

-- Insert values into Student table

INSERT INTO Student VALUES('s1', 'John Doe', 'Computer Science');
INSERT INTO Student VALUES('s2', 'Jane Smith', 'Electrical');
INSERT INTO Student VALUES('s3', 'Bob Johnson', 'Mechanical');
INSERT INTO Student VALUES('s4', 'Alice White', 'Civil');
INSERT INTO Student VALUES('s5', 'Charlie Brown', 'Physics');

-- Insert values into Course table

INSERT INTO Course VALUES ('c1', 3, 'T1', 'S1', 'Python');
INSERT INTO Course VALUES ('c2', 4, 'T2', 'S2', 'Electrical');
INSERT INTO Course VALUES ('c3', 3, 'T3', 'S3', 'Mechanical');
INSERT INTO Course VALUES ('c4', 3, 'T4', 'S4', NULL);
INSERT INTO Course VALUES ('c5', 3, 'T5', 'S5', NULL);
INSERT INTO Course VALUES ('c6', 3, 'T6', 'S5', NULL);
INSERT INTO Course VALUES ('c7', 3, 'T7', 'S5', 'Maths');

-- Insert values into Instructor table
INSERT INTO Instructor VALUES ('i1', 'N1', 'D1', 'A1');
INSERT INTO Instructor VALUES ('i2', 'N3', 'E1', 'B1');
INSERT INTO Instructor VALUES ('i3', 'N4', 'M1', 'A1');
INSERT INTO Instructor VALUES ('i4', 'N5', 'C1', 'A1');
INSERT INTO Instructor VALUES ('i5', 'N6', 'P1', 'B1');

-- Insert values into Course_offerings table

INSERT INTO Course_offerings VALUES ('r101', '2024', 'Spring', 'c1');
INSERT INTO Course_offerings VALUES ('r101', '2024', 'Spring', 'c2');
INSERT INTO Course_offerings VALUES ('r101', '2024', 'Spring', 'c4');
INSERT INTO Course_offerings VALUES ('r201', '2024', 'Fall', 'c2');
INSERT INTO Course_offerings VALUES ('r301', '2024', 'Spring', 'c3');
INSERT INTO Course_offerings VALUES ('r401', '2024', 'Fall', 'c4');
INSERT INTO Course_offerings VALUES ('r501', '2024', 'Spring', 'c5');
INSERT INTO Course_offerings VALUES ('r501', '2024', 'Spring', 'c6');
INSERT INTO Course_offerings VALUES ('r501', '2024', 'Fall', 'c7');

-- Insert values into teaches table
INSERT INTO teaches VALUES ('i1', '2024', 'Spring', 'c1');
INSERT INTO teaches VALUES ('i2', '2024', 'Fall', 'c2');
INSERT INTO teaches VALUES ('i3', '2024', 'Spring', 'c3');
INSERT INTO teaches VALUES ('i4', '2024', 'Fall', 'c4');
INSERT INTO teaches VALUES ('i1', '2024', 'Spring', 'c2');
INSERT INTO teaches VALUES ('i1', '2024', 'Spring', 'c4');

-- Insert values into enrolls table
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c1', 'A');
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c3', 'A');
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c5', 'A');
INSERT INTO enrolls VALUES ('s2', '2024', 'Fall', 'c2', 'B');
INSERT INTO enrolls VALUES ('s3', '2024', 'Spring', 'c3', 'A');
INSERT INTO enrolls VALUES ('s4', '2024', 'Fall', 'c4', 'B');
INSERT INTO enrolls VALUES ('s5', '2024', 'Spring', 'c5', 'A');
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c2', 'A');
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c4', 'A');
INSERT INTO enrolls VALUES ('s1', '2024', 'Spring', 'c6', 'A');

queries

a) select u.sid,u.course_no,c.Pcourse
   from enrolls1 u,course1 c
   where u.course_no=c.course_no;

b)
SELECT DISTINCT s.sid, s.name
FROM student1 s
JOIN enrolls1 e ON s.sid = e.sid
JOIN Course_offerings1 c ON e.course_no = c.course_no
WHERE c.sem = 'Spring'
GROUP BY s.sid, s.name
HAVING COUNT(DISTINCT e.course_no) = (SELECT COUNT(course_no) FROM Course_offerings1 WHERE sem = 'Spring');

c)
SELECT iid,name
from instructor1 
where iid in(select t.iid
	     from teaches1 t
	     join instructor1 a on t.iid=a.iid
	     where t.sem='Spring'
	     group by t.iid
	     having count(course_no)>=2
	);

d)
select course_no,title
from course1
where course_no NOT IN(
			select e.course_no
			from enrolls1 e
			join course_offerings1 c on e.course_no=c.course_no
			where year='2024' 
			);
select course_no,title
   from course1 u
   where course_no IN ( select course_no
			from course_offerings1
			 where year='2024' AND course_no NOT IN ( select course_no
								   from enrolls1));
