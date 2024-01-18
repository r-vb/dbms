Library Management

Create Table Book	(
			Book_id INT NOT NULL,
			Price INT NOT NULL,
			Title Varchar(20),
			Available Varchar(10),
			Pub_id Varchar(10),
			Primary Key(Book_id),
			Foreign Key(Pub_id) References Publisher(Pub_id) ON DELETE SET NULL
		 );

Create Table Publisher(
			Pub_id Varchar(10) NOT NULL,
			Name Varchar(20) NOT NULL,
			Address Varchar(30) NOT NULL,
			Primary Key(Pub_id)
			); 

Create Table Supplier(
			sup_id Varchar(20) NOT NULL,
			Name Varchar(20) NOT NULL,
			Address Varchar(20) NOT NULL,
			Primary Key(sup_id)
		    );

Create Table Member
			m_id Varchar(20) NOT NULL,
			Name Varchar(10) NOT NULL,
			Address Varchar(20) NOT NULL,
			Mem_Type Varchar(10) NOT NULL,
			Exp_date DATE NOT NULL,
			Mem_date DATE NOT NULL,
			Primary Key(m_id)
		   );

Create Table Book_Author(
				Book_id INT NOT NULL,
			 	Author Varchar(20) NOT NULL,
				Primary Key(Book_id,Author),
				FOREIGN KEY(Book_id) References Book(Book_id) ON DELETE SET NULL
			);

Create Table Borrowedby(	
				Book_id INT NOT NULL,
				m_id Varchar(20) NOT NULL,
				Return_date DATE,
				Due_date DATE,
				Issue_Date DATE, 
				Primary Key(Book_id,m_id),
				FOREIGN KEY(Book_id) References Book(Book_id) ON DELETE SET NULL,
				FOREIGN KEY(m_id) References Member(m_id) ON DELETE SET NULL
			);

Create Table SuppliedBy(
				Book_id INT NOT NULL,
				sup_id Varchar(20) NOT NULL,
				primary(book_id,sup_id),
				FOREIGN KEY(Book_id) References Book(Book_id) ON DELETE SET NULL,
				FOREIGN KEY(sup_id) References Supplier(sup_id) ON DELETE SET NULL
			);

INSERTION VALUES

-- Insert values into Publisher table
INSERT INTO Publisher VALUES ('P1', 'Publisher1', 'Address1');
INSERT INTO Publisher VALUES ('P2', 'Publisher2', 'Address2');
INSERT INTO Publisher VALUES ('P3', 'Publisher3', 'Address3');
INSERT INTO Publisher VALUES ('P4', 'Publisher4', 'Address4');
INSERT INTO Publisher VALUES ('P5', 'Publisher5', 'Address5');

-- Insert values into Supplier table

INSERT INTO Supplier VALUES ('S1', 'Supplier1', 'Address1');
INSERT INTO Supplier VALUES ('S2', 'Supplier2', 'Address2');
INSERT INTO Supplier VALUES ('S3', 'Supplier3', 'Address3');
INSERT INTO Supplier VALUES ('S4', 'Supplier4', 'Address4');
INSERT INTO Supplier VALUES ('S5', 'Supplier5', 'Address5');

-- Insert values into Book table
INSERT INTO Book VALUES (1, 20, 'Book1', 'Yes', 'P1');
INSERT INTO Book VALUES (2, 30, 'Book2', 'No', 'P2');
INSERT INTO Book VALUES (3, 25, 'Book3', 'Yes', 'P3');
INSERT INTO Book VALUES (4, 35, 'Book4', 'No', 'P4');
INSERT INTO Book VALUES (5, 22, 'Book5', 'Yes', 'P5');

-- Insert values into Member table
INSERT INTO Member VALUES ('M1', 'Member1', 'Address1', 'Type1', '17-JAN-2023', '20-JAN-2019');
INSERT INTO Member VALUES ('M2', 'Member2', 'Address2', 'Type2', '01-JAN-2023', '17-FEB-2019');
INSERT INTO Member VALUES ('M3', 'Member3', 'Address3', 'Type3', '01-JAN-2023', '17-SEP-2019');
INSERT INTO Member VALUES ('M4', 'Member4', 'Address4', 'Type4', '01-JAN-2022', '07-MAR-2019');
INSERT INTO Member VALUES ('M5', 'Member5', 'Address5', 'Type5', '01-JAN-2021', '08-JAN-2019');


-- Insert values into Book_Author table
INSERT INTO Book_Author VALUES (1, 'Author1');
INSERT INTO Book_Author VALUES (2, 'Author2');
INSERT INTO Book_Author VALUES (3, 'Author3');
INSERT INTO Book_Author VALUES (4, 'Author4');
INSERT INTO Book_Author VALUES (5, 'Author5');

-- Insert values into Borrowedby table
INSERT INTO borrowedby VALUES (1, 'M1', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (2, 'M2', TO_DATE('31-12-2023','DD-MM-YYYY'), TO_DATE('15-11-2023','DD-MM-YYYY'), TO_DATE('20-12-2023','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (3, 'M3', TO_DATE('30-06-2025','DD-MM-YYYY'), TO_DATE('15-05-2025','DD-MM-YYYY'), NULL);
INSERT INTO borrowedby VALUES (2, 'M1', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (3, 'M1', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (1, 'M2', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (3, 'M2', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));
INSERT INTO borrowedby VALUES (2, 'M4', TO_DATE('31-01-2024','DD-MM-YYYY'), TO_DATE('15-12-2023','DD-MM-YYYY'), TO_DATE('20-01-2024','DD-MM-YYYY'));

INSERT INTO SuppliedBy VALUES (1, 'S1');
INSERT INTO SuppliedBy VALUES (2, 'S2');
INSERT INTO SuppliedBy VALUES (3, 'S3');
INSERT INTO SuppliedBy VALUES (4, 'S4');
INSERT INTO SuppliedBy VALUES (5, 'S5');


QUERIES:
a) select s.sup_id,s.name
   from supplier s
   join suppliedby sb on s.sup_id=sb.sup_id
   join book b on sb.book_id=b.book_id
   join publisher p on b.pub_id=p.pub_id
   where p.name='Publisher1';


SELECT s.sup_id, s.name
FROM supplier s
WHERE s.sup_id NOT IN (
    SELECT sb.sup_id
    FROM suppliedby sb
    JOIN book b ON sb.book_id = b.book_id
    JOIN publisher p ON b.pub_id = p.pub_id
    MINUS
    SELECT sb.sup_id
    FROM suppliedby sb
    JOIN book b ON sb.book_id = b.book_id
    JOIN publisher p ON b.pub_id = p.pub_id
    WHERE p.name = 'Publisher1'
);


b) select m.m_id,m.name
   from member m
   where m.m_id NOT IN(select distinct m_id
			     from borrowedby);

c) select m.m_id,m.name
   from member m
   where m_id IN (select m_id
			from borrowedby
		        group by m_id
   			having count(book_id)>2);

d) select book_id,title
   from book
   where book_id IN(select book_id
			from borrowedby
			group by book_id
			having count(m_id)>=All(select count(m_id)
							from borrowedby
							group by book_id));
