CREATE DATABASE CAR_RENTAL

CREATE TABLE VEHICLE(
VEHICLEID INT IDENTITY PRIMARY KEY,
MAKE VARCHAR(50),
MODEL VARCHAR(50),
YEARS INT,
DAILYRATE DECIMAL(10,2),
AVAILABLE INT,
PASSENGERCAPACITY INT,
ENGINECAPACITY INT
)

CREATE TABLE CUSTOMER(
CUSTOMERID INT IDENTITY PRIMARY KEY,
FIRSTNAME VARCHAR(50),
LASTNAME VARCHAR(50),
EMAIL VARCHAR(50) UNIQUE,
PHONENUMBER VARCHAR(50),
)

CREATE TABLE LEASE(
LEASEID INT IDENTITY PRIMARY KEY,
VEHICLEID INT,
CUSTOMERID INT,
STARTDATE DATE,
ENDDATE DATE,
LEASETYPE VARCHAR(20)
FOREIGN KEY (VEHICLEID)REFERENCES VEHICLE(VEHICLEID),
FOREIGN KEY (CUSTOMERID)REFERENCES CUSTOMER(CUSTOMERID)
)

CREATE TABLE PAYMENT(
PAYMENTID INT IDENTITY PRIMARY KEY,
LEASEID INT,
PAYMENTDATE DATE,
AMOUNT DECIMAL(10,2),
FOREIGN KEY (LEASEID)REFERENCES LEASE(LEASEID)
)


INSERT INTO VEHICLE VALUES('Toyota','Camry', 2022, 50.00 ,1, 4, 1450), 
                           ('Honda','Civic', 2023, 45.00, 1, 7, 1500), 
                           ('Ford','Focus', 2022, 48.00, 0, 4, 1400), 
                           ('Nissan','Altima', 2023, 52.00, 1, 7, 1200), 
                           ('Chevrolet','Malibu', 2022, 47.00, 1, 4,1800), 
                           ('Hyundai','Sonata', 2023, 49.00, 0, 7, 1400), 
                           ('BMW 3','Series', 2023, 60.00, 1, 7, 2499),
						   ('Mercedes','C-Class', 2022, 58.00, 1, 8, 2599),
						   ('Audi','A4', 2022, 55.00, 0, 4, 2500),
						   ('Lexus','ES',2023, 54.00, 1, 4, 2500)



INSERT INTO CUSTOMER VALUES('John','Doe','johndoe@example.com','555-555-5555'), 
                            ('Jane',' Smith','janesmith@example.com','555-123-4567'), 
							 ('Robert','Johnson','robert@example.com','555-789-1234'),
							 ('Sarah','Brown','sarah@gmail.com','555-456-7890'),
							 ('David','Lee','david@example.com','555-987-6543'),
							 ('Laura','Hall','laura@example.com','555-234-5678'),
							 ('Michael','Davis','michael@example.com','555-876-5432'), 
							 ('Emma','Wilson','emma@example.com','555-432-1098'), 
							 ('William','Taylor','william@example.com','555-321-6547'),
							 ('Olivia','Adams','olivia@example.com','555-765-4321')


INSERT INTO LEASE VALUES(1, 1, '20230101','2023-01-05','Daily'),
                        (2, 2, '20230215', '20230228', 'Monthly'), 
						(3, 3, '20230310', '20230315', 'Daily'), 
						(4, 4, '20230420', '20230430', 'Monthly'), 
						(5, 5, '20230505','20230510','Daily'),
						(4, 3, '20230615', '20230630','Monthly'),
					     (7, 7, '20230701', '20230710','Daily'), 
						 ( 8, 8, '20230812', '20230815','Monthly'), 
						 (3, 3, '20230907', '20230910','Daily'), 
						 (10, 10, '20231010','20231031','Monthly') 



INSERT INTO PAYMENT VALUES(1,'20230103',200.00),
                           (2,'20230220',1000.00), 
						   (3, '20230312',75.00),
						   (4,'20230425',900.00),
						   (5,'20230507',60.00),
						   (6,'20230618',1200.00),
						   (7,'20230703',40.00),
						   (8,'20230814',1100.00),
						   (9,'20230909',80.00),
						   (10,'20231025',1500.00)


--1. Update the daily rate for a Mercedes car to 68. 
UPDATE VEHICLE
SET DAILYRATE=68
WHERE MAKE='MERCEDES'

--2. Delete a specific customer and all associated leases and payments. 
DELETE FROM CUSTOMER 
WHERE CUSTOMERID=10 AND LEASEID=1



--3. Rename the "paymentDate" column in the Payment table to "transactionDate". 
EXEC sp_rename 'PAYMENT.PAYMENTDATE','TRANSACTIONDATE','COLUMN'
SELECT * FROM PAYMENT


--4. Find a specific customer by email. 
SELECT * FROM CUSTOMER WHERE EMAIL='sarah@gmail.com'


--5. Get active leases for a specific customer. 
SELECT * FROM LEASE
WHERE CUSTOMERID=1 AND GETDATE()BETWEEN STARTDATE AND ENDDATE


--6. Find all payments made by a customer with a specific phone number. 
SELECT P.PAYMENTID,P.TRANSACTIONDATE,P.AMOUNT,C.CUSTOMERID,
CONCAT(C.FIRSTNAME,LASTNAME)AS NAME,C.PHONENUMBER
FROM PAYMENT AS P
JOIN CUSTOMER AS C ON
C.CUSTOMERID=P.PAYMENTID
WHERE PHONENUMBER='555-555-5555'




--7. Calculate the average daily rate of all available cars. 
SELECT MAKE,AVG(DAILYRATE) AS AVGDAILYRATE
FROM VEHICLE
GROUP BY MAKE


--8. Find the car with the highest daily rate. 
SELECT TOP 1 MAKE,DAILYRATE
FROM VEHICLE
ORDER BY DAILYRATE DESC 


--9. Retrieve all cars leased by a specific customer.

SELECT L.LEASEID,L.VEHICLEID,V.MAKE,C.CUSTOMERID,C.FIRSTNAME
FROM LEASE AS L
JOIN VEHICLE AS V ON
L.LEASEID=V.VEHICLEID
JOIN CUSTOMER AS C ON
L.LEASEID=C.CUSTOMERID
WHERE C.FIRSTNAME='ROBERT'


--10. Find the details of the most recent lease. 
SELECT TOP 1 * FROM LEASE
ORDER BY ENDDATE DESC





--11. List all payments made in the year 2023. 
SELECT * FROM PAYMENT WHERE 
YEAR(TRANSACTIONDATE)=2023



--12. Retrieve customers who have not made any payments. 

SELECT * FROM CUSTOMER AS C
WHERE NOT EXISTS ( SELECT 1 FROM LEASE l JOIN PAYMENT P ON L.LEASEID = P.LEASEID
    WHERE L.CUSTOMERID =C.CUSTOMERID)


--13. Retrieve Car Details and Their Total Payments.
SELECT V.*,P.LEASEID,P.AMOUNT
FROM VEHICLE AS V
JOIN PAYMENT AS P
ON V.VEHICLEID=P.PAYMENTID

--14. Calculate Total Payments for Each Customer. 
SELECT C.*,P.PAYMENTID,P.AMOUNT FROM CUSTOMER AS C
JOIN PAYMENT AS P ON
C.CUSTOMERID=P.PAYMENTID

--15. List Car Details for Each Lease. 
SELECT V.*,L.LEASEID
FROM VEHICLE AS V
JOIN LEASE AS L ON
V.VEHICLEID=L.LEASEID


--16. Retrieve Details of Active Leases with Customer and Car Information. 
SELECT * FROM LEASE
SELECT * FROM PAYMENT
SELECT L.*,V.*,C.FIRSTNAME FROM LEASE AS L
JOIN CUSTOMER AS C ON 
C.CUSTOMERID=L.CUSTOMERID
JOIN VEHICLE AS V ON
V.VEHICLEID=L.VEHICLEID
WHERE GETDATE()BETWEEN STARTDATE AND ENDDATE



--17. Find the Customer Who Has Spent the Most on Leases.
SELECT TOP 1 C.*,P.AMOUNT FROM CUSTOMER AS C
JOIN PAYMENT AS P ON 
C.CUSTOMERID=P.LEASEID
ORDER BY AMOUNT DESC
--18. List All Cars with Their Current Lease Information.
SELECT V.MAKE,L.*
FROM VEHICLE AS V
JOIN LEASE AS L ON
V.VEHICLEID=L.VEHICLEID