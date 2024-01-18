SUPPLY CHAIN MANAGEMENT


create table Project(
			Pnumber INT NOT NULL,
			ProjName VARCHAR(20) NOT NULL,
		        PRIMARY KEY(Pnumber)
		     );

Create Table Projectloc(
			Pnumber INT NOT NULL,
			PLocation VARCHAR(20) NOT NULL,
			PRIMARY KEY(Pnumber,PLocation),
			Foreign Key(Pnumber) References Project(Pnumber) ON DELETE SET NULL
			); 

Create Table Company(   CNum VARCHAR(5) NOT NULL,
			Cname VARCHAR(20) NOT NULL,
			PRIMARY KEY(CNum)
			);

Create table Part(
			Partno VARCHAR(5) NOT NULL,
			Material VARCHAR(20) NOT NULL,
			Type VARCHAR(20) NOT NULL,
			Price INT NOT NULL,
			PRIMARY KEY(PartNo)
		);

Create table Supplier_chain(
			Snum VARCHAR(20) NOT NULL,
			Sname VARCHAR(20) NOT NULL,
			PRIMARY KEY(Snum));

Create Table Supply(
			Snum VARCHAR(20) NOT NULL,
			Pnumber INT NOT NULL, 
			Partno VARCHAR(5) NOT NULL,
			Quantity INT, 
			PRIMARY KEY(Snum,Pnumber,PartNo),	
			Foreign Key(Snum) References Supplier_chain(Snum) ON DELETE SET NULL,
			Foreign Key(Pnumber) References Project(Pnumber) ON DELETE SET NULL,
			Foreign Key(Partno) References Part(Partno) ON DELETE SET NULL 
			);

Create Table ManufacturedBy(
				Partno VARCHAR(5) NOT NULL,
				CNum VARCHAR(5) NOT NULL,
				Foreign Key(Partno) References Part(Partno) ON DELETE SET NULL,
				Foreign Key(CNum) References Company(CNum) ON DELETE SET NULL 
			);

Insertion Values

INSERT INTO Supplier_chain VALUES ('s1', 'sA');
INSERT INTO Supplier_chain VALUES ('s2', 'sB');
INSERT INTO Supplier_chain VALUES ('s3', 'sC');

INSERT INTO project VALUES (1, 'P1');
INSERT INTO project VALUES (2, 'P2');
INSERT INTO project VALUES (3, 'P3');

INSERT INTO part VALUES ('Part1', 'M1', 'T1', 50);
INSERT INTO part VALUES ('Part2', 'M2', 'T2', 30);
INSERT INTO part VALUES ('Part3', 'M3', 'T3', 20);

INSERT INTO company VALUES ('C1', 'CompanyX');
INSERT INTO company VALUES ('C2', 'CompanyY');
INSERT INTO company VALUES ('C3', 'CompanyZ');

INSERT INTO supply VALUES ('s1', 1, 'Part1', 100);
INSERT INTO supply VALUES ('s1', 1, 'Part2', 100);
INSERT INTO supply VALUES ('s2', 2, 'Part2', 75);
INSERT INTO supply VALUES ('s3', 3, 'Part3', 50);
INSERT INTO supply VALUES ('s3', 2, 'Part3', 50);

INSERT INTO projectloc VALUES (1, 'LocationA');
INSERT INTO projectloc VALUES (2, 'LocationB');
INSERT INTO projectloc VALUES (3, 'LocationC');

INSERT INTO ManufacturedBy VALUES ('Part1', 'C1');
INSERT INTO ManufacturedBy VALUES ('Part2', 'C2');
INSERT INTO ManufacturedBy VALUES ('Part3', 'C3'); 

Queries;

1)
SELECT DISTINCT(S.Sname),p.Partno,c.Cname
FROM Supplier_chain s
JOIN supply a on s.snum=a.snum
JOIN ManufacturedBy p on a.Partno=p.partno
JOIN Company c on p.cnum=c.cnum
where a.Pnumber=1;

select DISTINCT(s.sname),m.partno,c.cname
from company c,manufacturedby m,supplier_chain s
join supply u on s.snum=u.snum
join part p on p.partno=u.partno
where m.partno=u.partno AND m.cnum=c.cnum AND pnumber=1;

2)
select DISTINCT snum,sname
from supplier_chain s
where snum NOT IN(
		SELECT s.snum
		FROM supply s
		JOIN ManufacturedBy m on s.partno=m.partno
		MINUS
		SELECT s.snum
		FROM supply s
		JOIN ManufacturedBy m on s.partno=m.partno
		WHERE m.cnum='C1'
	     );

3)
	SELECT Distinct(Pnumber),ProjName
	from project 
	where Pnumber in(  SELECT s.Pnumber
			   from supply s
		           join part p on s.partno=p.partno
			   where p.price>=ALL(SELECT max(price) FROM PART));

   select p.pnumber,p.projname
   from project p
   join supply s on s.pnumber=p.pnumber
   join part t on t.partno=s.partno
   where t.price>=(select max(price)
		   from part);

4)
   select distinct s.snum,s.sname
   from supplier_chain s
   join supply u on u.snum=s.snum
   where u.snum IN (select snum
		    from supply
		   group by snum
		  having count(pnumber)>=2); 
