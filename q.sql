-- supply chain ---------------------------------------------------------------------------------

create table supplier(
	snum int not null,
	sname varchar(50) not null,
	primary key(snum));

insert into supplier values(1,'SupplierA');
insert into supplier values(2,'SupplierB');
insert into supplier values(3,'SupplierC');

create table project(
	pnum int not null,
	projname varchar(50) not null,
	primary key(pnum));

insert into project values (101,'ProjectX');
insert into project values (102,'ProjectY');
insert into project values (103,'ProjectZ');

create table project_loc(
	pnum int,
	ploc varchar(50) not null,
	primary key(pnum,ploc),
	foreign key(pnum) references project(pnum));

insert into project_loc values (101,'LocationA');
insert into project_loc values (102,'LocationB');
insert into project_loc values (103,'LocationC');

create table part(
	part_no int not null,
	material varchar(50) not null,
	type varchar(50) not null,
	price int not null,
	primary key(part_no));

insert into part values (1001,'Metal','ComponentA', 30);
insert into part values (1002,'Plastic','ComponentB',45);
insert into part values (1003,'Glass','ComponentC',50);

create table company(
	cnum int not null,
	cname varchar(50) not null,
	primary key(cnum));

insert into company values (201,'CompanyX');
insert into company values (202,'CompanyY');
insert into company values (203,'CompanyZ');

create table manufac_by(
	part_no int,
	cnum int,
	primary key(part_no,cnum),
	foreign key(part_no) references part(part_no),
	foreign key(cnum) references company(cnum));

insert into manufac_by values (1001,201);
insert into manufac_by values (1002,202);
insert into manufac_by values (1003,203);

create table supply(
	snum int,
	pnum int,
	part_no int,
	quantity int,
	primary key(snum,pnum,part_no),
	foreign key(snum) references supplier(snum),
	foreign key(pnum) references project(pnum),
	foreign key(part_no) references part(part_no));

insert into supply values (1,101,1001,50);
insert into supply values (2,102,1002,45);
insert into supply values (3,103,1003,40);


a) SELECT s.sname, m.part_no, c.cname
    FROM company c, manufac_by m, supplier s
    JOIN supply u on s.snum = u.snum
    JOIN part p on p.part_no = u.part_no
    WHERE m.part_no = u.part_no AND m.cnum=c.cnum AND pnum=101;

b) SELECT DISTINCT s.snum, s.sname
    FROM company c, manufac_by m, supplier s
    JOIN supply u ON s.snum=u.snum
    WHERE m.part_no = u.part_no and m.part_no = ALL (
		SELECT DISTINCT m.part_no
    		FROM manufac_by m, company c
    		WHERE m.cnum = c.cnum AND c.cname = 'CompanyX'
    );

c) SELECT p.pnum, p.projname
    FROM project p
    JOIN supply s ON s.pnum = p.pnum
    JOIN part t ON t.part_no = s.part_no
    WHERE t.price >= (
		SELECT MAX(price)
   		FROM part
    );

d) SELECT DISTINCT s.snum, s.sname
    FROM supplier s
    JOIN supply u on u.snum = s.snum
    WHERE u.snum IN (
		 SELECT snum
		 FROM supply
		 GROUP BY snum
		 HAVING COUNT(pnum)>1
    );
-----------------------------------------------------------------------------------------------------------------

-- library ---------------------------------------------------------------------------------------

create table book(
	book_id int NOT NULL,
 	title varchar(20),
	avalibility int,
	price int,
	primary key (book_id));
create table publisher(
	pub_id int NOT NULL,
	paddress varchar(20),
	pname varchar(10),
	book_id int,
	primary key (pub_id),
	foreign key(book_id) references book(book_id) on delete set null);
create table bauthor(
	book_id int,
	author varchar(20),
	primary key(book_id,author),
	foreign key(book_id) references book(book_id) on delete set null);
create table supplier1(
	sup_id int NOT NULL,
	sname varchar(10),
	saddress varchar(20),
	primary key(sup_id));
create table suppliedby(
	book_id int,
	sup_id int,
	primary key(book_id,sup_id),
	foreign key(book_id) references book(book_id) on delete set null,
	foreign key(sup_id) references supplier1(sup_id) on delete set null);
create table member1(
	member_id int NOT NULL,
	exp_date date,
	mname varchar(20),
	maddress varchar(20),
	memb_type varchar(10),
	memb_date date,
	primary key(member_id));
create table borrowedby(
	book_id int,
	member_id int,
	due_date date,
	issue_date date,
	return_date date,
	primary key(book_id,member_id),
	foreign key(book_id) references book(book_id) on delete set null,
	foreign key(member_id) references member1(member_id) on delete set null);



-- Insert values into 'book' table
INSERT INTO book VALUES (1, 'The Great Gatsby', 5, 20);
INSERT INTO book VALUES (2, 'To Kill', 3, 15);
INSERT INTO book VALUES (3, '1984', 8, 25);

INSERT INTO publisher VALUES (101, 'PublisherA Add', 'PublisherA', 1);
INSERT INTO publisher VALUES (102, 'PublisherB Add', 'PublisherB', 2);
INSERT INTO publisher VALUES (103, 'PublisherC Add', 'PublisherC', 3);

INSERT INTO bauthor VALUES (1, 'F. Scott ');
INSERT INTO bauthor VALUES (2, 'Harper Lee');
INSERT INTO bauthor VALUES (3, 'George Orwell');

INSERT INTO supplier1 VALUES (201, 'SupplierX', 'SupplierX Add');
INSERT INTO supplier1 VALUES (202, 'SupplierY', 'SupplierY Add');
INSERT INTO supplier1 VALUES (203, 'SupplierZ', 'SupplierZ Add');

INSERT INTO suppliedby VALUES (1, 201);
INSERT INTO suppliedby VALUES (2, 202);
INSERT INTO suppliedby VALUES (3, 203);

INSERT INTO member1 VALUES (301, TO_DATE('31-12-2024','DD-MM-YYYY'), 'MemberA', 'AddressA', 'Regular', TO_DATE('15-01-2020','DD-MM-YYYY'));
INSERT INTO member1 VALUES (302, TO_DATE('30-11-2023','DD-MM-YYYY'), 'MemberB', 'AddressB', 'Premium', TO_DATE('20-05-2021','DD-MM-YYYY'));
INSERT INTO member1 VALUES (303, TO_DATE('31-05-2025','DD-MM-YYYY'), 'MemberC', 'AddressC', 'Regular', TO_DATE('10-09-2022','DD-MM-YYYY'));

INSERT INTO borrowedby VALUES (1, 301, TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (2, 302, TO_DATE('31-12-2023','DD-MM-YYYY'), TO_DATE('15-11-2023','DD-MM-YYYY'), TO_DATE('20-12-2023','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (3, 303, TO_DATE('30-06-2025','DD-MM-YYYY'), TO_DATE('15-05-2025','DD-MM-YYYY'), NULL);

queires
4
a) select s.sup_id,s.sname
   from supplier1 s
   join suppliedby sb on s.sup_id=sb.sup_id
   join publisher p on p.book_id=sb.book_id
   where p.pname='PublisherB';

b) select m.member_id,m.mname
   from member1 m
   where m.member_id NOT IN(select distinct member_id
			     from borrowedby);

c) select m.member_id,m.mname
   from member1 m
   where member_id IN (select member_id
			from borrowedby
		       group by member_id
   			having count(book_id)>2);

d) select book_id,title
   from book
   where book_id IN(select book_id
			from borrowedby
			group by book_id
			having count(member_id)>=All(select count(member_id)
							from borrowedby
	
						group by book_id));

-----------------------------------------------------------------------------------

-- hospital managment ---------------------------------------------------------------------------------------

create table patient 
(
ssid int not null,
date_admitted date not null,
pname varchar(500) not null,
ins varchar(1000) not null,
checkout_date date not null,
primary key (ssid,date_admitted)
);
INSERT INTO patient VALUES(123456, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 'John Doe', 'XYZ Insurance', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO patient VALUES(789012, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'Jane Smith', 'ABC Insurance', TO_DATE('2024-01-25', 'YYYY-MM-DD'));
INSERT INTO patient VALUES(123456, TO_DATE('2024-04-17', 'YYYY-MM-DD'), 'John Doe', 'XYZ Insurance', TO_DATE('2024-06-20', 'YYYY-MM-DD'));

create table doctor 
(
did int not null primary key,
dname varchar(1000) not null,
speci varchar(1000) not null
);

INSERT INTO doctor VALUES (1, 'Dr. Smith', 'Cardiologist');
INSERT INTO doctor VALUES (2, 'Dr. Johnson', 'Orthopedic Surgeon');
INSERT INTO doctor VALUES (3, 'Dr. Davis', 'Pediatrician');


create table test_on
(
testid int not null primary key,
tname varchar(1000) not null
);
INSERT INTO test_on VALUES (1, 'Blood Test');
INSERT INTO test_on VALUES  (2, 'X-ray');
INSERT INTO test_on VALUES  (3, 'MRI Scan');

create table dr_patient
(
ssid int not null,
date_admitted date not null,
did int not null,
primary key (ssid,date_admitted,did),
foreign key (ssid,date_admitted) references patient(ssid,date_admitted),
foreign key (did) references doctor(did)
);

INSERT INTO dr_patient VALUES (123456, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 1); 
INSERT INTO dr_patient VALUES(789012, TO_DATE('2024-01-18','YYYY-MM-DD'), 2);
INSERT INTO dr_patient VALUES(123456, TO_DATE('2024-04-17', 'YYYY-MM-DD'), 3); 

 create table test_log
(
ssid int not null,
date_admitted date not null,
did int not null,
testid int not null ,
primary key (ssid,date_admitted,did,testid),
foreign key (ssid,date_admitted) references patient(ssid,date_admitted),
foreign key (did) references doctor(did),
foreign key (testid) references test_on(testid)
);
INSERT INTO test_log VALUES (123456, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 1, 1); 
INSERT INTO test_log VALUES (789012, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 2, 2); 

1]LIST THE patient name who were admitted more than twice in year 2024

select ssid ,count(date_admitted) as no_of_times
from patient 
where date_admitted like '%24'
group by ssid
having count(date_admitted) >= 2;


2]	select pname,ssid
	from patient 
	where ssid in(
	select  t.ssid
	from patient p,test_log t
	where p.ssid=t.ssid and p.date_admitted=t.date_admitted);


3]	list test id that has been performed highest number of times

select testid,count(testid) as no_of_times
	from test_log
	group by testid
	having count(testid) >= all
	(select max(no_of_times)
	from
	(select testid,count(testid) as no_of_times
	from test_log
	group by testid)
);


4]
select did,
from dr_patient
where ssid =
(select ssid 
from dr_patient
where did = (select did
		from doctor
		where dname='Dr. Smith')
);



--------------
4> SELECT dp.did, d.dname
FROM dr_patient dp
JOIN doctor d ON dp.did = d.did
WHERE dp.ssid = (
    SELECT ssid 
    FROM dr_patient
    WHERE did = (
        SELECT did
        FROM doctor
        WHERE dname = 'Dr. Smith'
    )
);

-----------------------------------------------------------------------------------

-- universitydb ---------------------------------------------------------------------------------------

create table student(
	sid varchar(8) primary key,
	name varchar(25),
	program varchar(10) 
);

create table instructor(
	iid varchar(8) primary key,
	name varchar(25),
	dept varchar(10),
	title varchar(10) 
 );

create table course(
	courseno int primary key,
	title varchar(25),
	credit int,
	syllabus varchar(25),
	pcourseno int,
	foreign key(pcourseno) references course(courseno) 
 );

create table courseoffering(
	courseno int ,
	year int,
	semester int,
	room int,
	foreign key (courseno) references course(courseno) ,
	primary key(courseno,year,semester)
);

create table enrols(
	courseno int ,
	year int,
	semester int,
	sid varchar(8),
	grade varchar(2),
foreign key (courseno,year,semester) references courseoffering(courseno,year,semester) ,
	foreign key (sid) references student(sid) ,
	primary key(courseno,year,semester,sid)
);

create table teaches(
	courseno int ,
	year int,
	semester int,
	iid varchar(8),
foreign key (courseno,year,semester) references courseoffering(courseno,year,semester) ,
foreign key (iid) references  instructor(iid) ,
	primary key(courseno,year,semester,iid)
);

-- Sample data for student table
INSERT INTO student VALUES ('S001', 'John Doe', 'Computer');
INSERT INTO student VALUES ('S002', 'Jane Smith', 'Engine');
INSERT INTO student VALUES ('S003', 'Bob Johnson', 'Physics');

-- Sample data for instructor table
INSERT INTO instructor VALUES ('I001', 'Brown', 'Computer', 'aProfessor');
INSERT INTO instructor VALUES ('I002', 'White', 'Engine', 'Professor');

-- Sample data for course table
INSERT INTO course VALUES (101, 'Programming', 4, 'Datas', 102);
INSERT INTO course VALUES (102, 'Data Structures', 3, 'DataStructSyllabus', null);
INSERT INTO course VALUES (201, 'CompNetworks', 4, 'CompNet yllabus', 101);
INSERT INTO course VALUES (103, 'Comp', 4, 's', 201);

-- Sample data for courseoffering table
INSERT INTO courseoffering VALUES (101, 2022, 1, 101);
INSERT INTO courseoffering VALUES (102, 2022, 2, 102);
INSERT INTO courseoffering VALUES (201, 2022, 1, 201);
INSERT INTO courseoffering VALUES (103, 2022, 1, 101);

-- Sample data for enrols table
INSERT INTO enrols VALUES (101, 2022, 1, 'S001', 'A');
INSERT INTO enrols VALUES (201, 2022, 1, 'S001', 'A');
INSERT INTO enrols VALUES (102, 2022, 2, 'S002', 'B');
INSERT INTO enrols VALUES (201, 2022, 1, 'S003', 'A-');

-- Sample data for teaches table
INSERT INTO teaches VALUES (101, 2022, 1, 'I001');
INSERT INTO teaches VALUES (102, 2022, 2, 'I002');
INSERT INTO teaches VALUES (201, 2022, 1, 'I001');

1--------

SQL> select s.sid,e.courseno,c.pcourseno
  2  from student s,enrols e,course c
  3  where s.sid=e.sid AND e.courseno=c.courseno;

SID        COURSENO  PCOURSENO
-------- ---------- ----------
S002            102
S001            101        102
S003            201        101

2---------------


SQL> SELECT s.sid
  2  FROM student s
  3  WHERE NOT EXISTS (
  4      SELECT courseno
  5      FROM courseoffering
  6      WHERE year = 2022 AND semester = 1
  7      MINUS
  8      SELECT courseno
  9      FROM enrols e
 10      WHERE e.sid = s.sid AND year = 2022 AND semester = 1
 11  );

SID
--------
S001



3--------

SELECT i.iid, i.name
FROM instructor i, teaches t, courseoffering c
WHERE i.iid = t.iid AND c.courseno = t.courseno AND c.year = 2022 AND c.semester = 1
GROUP BY i.iid, i.name
HAVING COUNT(c.courseno) =2;

IID      NAME
-------- -------------------------
I001     Brown


2---------------


SQL> SELECT s.sid
  2  FROM student s
  3  WHERE NOT EXISTS (
  4      SELECT courseno
  5      FROM courseoffering
  6      WHERE year = 2022 AND semester = 1
  7      MINUS
  8      SELECT courseno
  9      FROM enrols e
 10      WHERE e.sid = s.sid AND year = 2022 AND semester = 1
 11  );

SID
--------
S001




EXTRA:
SQL> SELECT i.name
  2  FROM instructor i
  3  WHERE NOT EXISTS (
  4      SELECT courseno
  5      FROM courseoffering
  6      WHERE year = 2022 AND semester = 1
  7      MINUS
  8      SELECT courseno
  9      FROM teaches t
 10      WHERE i.iid = t.iid AND year = 2022 AND semester = 1
 11  );

NAME
-------------------------
Brown


SELECT courseno, title
FROM course
WHERE courseno NOT IN (
    (SELECT co.courseno
    FROM courseoffering co
    WHERE co.year = 2022
    INTERSECT
    SELECT e.courseno
    FROM enrols e
    WHERE e.year = 2022)
);

--------------------------------------------------------------------------------
>>supply chain 

create table supplier(
	snum int not null,
	sname varchar(50) not null,
	primary key(snum));

insert into supplier values(1,'SupplierA');
insert into supplier values(2,'SupplierB');
insert into supplier values(3,'SupplierC');

create table project(
	pnum int not null,
	projname varchar(50) not null,
	primary key(pnum));

insert into project values (101,'ProjectX');
insert into project values (102,'ProjectY');
insert into project values (103,'ProjectZ');

create table project_loc(
	pnum int,
	ploc varchar(50) not null,
	primary key(pnum,ploc),
	foreign key(pnum) references project(pnum));

insert into project_loc values (101,'LocationA');
insert into project_loc values (102,'LocationB');
insert into project_loc values (103,'LocationC');

create table part(
	part_no int not null,
	material varchar(50) not null,
	type varchar(50) not null,
	price int not null,
	primary key(part_no));

insert into part values (1001,'Metal','ComponentA', 30);
insert into part values (1002,'Plastic','ComponentB',45);
insert into part values (1003,'Glass','ComponentC',50);

create table company(
	cnum int not null,
	cname varchar(50) not null,
	primary key(cnum));

insert into company values (201,'CompanyX');
insert into company values (202,'CompanyY');
insert into company values (203,'CompanyZ');

create table manufac_by(
	part_no int,
	cnum int,
	primary key(part_no,cnum),
	foreign key(part_no) references part(part_no),
	foreign key(cnum) references company(cnum));

insert into manufac_by values (1001,201);
insert into manufac_by values (1002,202);
insert into manufac_by values (1003,203);

create table supply(
	snum int,
	pnum int,
	part_no int,
	quantity int,
	primary key(snum,pnum,part_no),
	foreign key(snum) references supplier(snum),
	foreign key(pnum) references project(pnum),
	foreign key(part_no) references part(part_no));

insert into supply values (1,101,1001,50);
insert into supply values (2,102,1002,45);
insert into supply values (3,103,1003,40);


a) SELECT s.sname, m.part_no, c.cname
    FROM company c, manufac_by m, supplier s
    JOIN supply u on s.snum = u.snum
    JOIN part p on p.part_no = u.part_no
    WHERE m.part_no = u.part_no AND m.cnum=c.cnum AND pnum=101;

b) SELECT DISTINCT s.snum, s.sname
    FROM company c, manufac_by m, supplier s
    JOIN supply u ON s.snum=u.snum
    WHERE m.part_no = u.part_no and m.part_no = ALL (
		SELECT DISTINCT m.part_no
    		FROM manufac_by m, company c
    		WHERE m.cnum = c.cnum AND c.cname = 'CompanyX'
    );

c) SELECT p.pnum, p.projname
    FROM project p
    JOIN supply s ON s.pnum = p.pnum
    JOIN part t ON t.part_no = s.part_no
    WHERE t.price >= (
		SELECT MAX(price)
   		FROM part
    );

d) SELECT DISTINCT s.snum, s.sname
    FROM supplier s
    JOIN supply u on u.snum = s.snum
    WHERE u.snum IN (
		 SELECT snum
		 FROM supply
		 GROUP BY snum
		 HAVING COUNT(pnum)>1
    );
