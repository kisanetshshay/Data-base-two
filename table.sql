CREATE SCHEMA sales;
CREATE Table sales.employee(
    EmployeeID SERIAL PRIMARY KEY,
    FristName VARCHAR(30),
    lastname VARCHAR(20),
    Gender VARCHAR(10),
    Departement VARCHAR(15),
    HireDate DATE,
    Salary DECIMAL (10,2)
);
SELECT * FROM sales.employee

INSERT INTO sales.employee(
    FristName ,
    lastname ,
    Gender ,
    Departement ,
    HireDate ,
    Salary 
)VALUES
('John','Doe','Male','IT','2018-05-01','6000'),
('Jane','Smith','Female','HR','2019-06-15','50000'),
('Micheal','Jhonson','Male','Finance','2017-03-10','75000'),
('Emily','Davis','Female','IT','2020-11-20','70000'),
('Sarah','Brown','Female','marketing','2016-07-30','45000'),
('David','Wilson','Male','Sales','2019-01-05','55000'),
('Chirs','Taylor','Male','IT','2022-02-25','65000')

SELECT * FROM sales.employee

CREATE Table sales.products(
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(30),
    Catagory VARCHAR(20),
    Price DECIMAL (10,2),
    Stock INT 
);
SELECT * FROM sales.products

INSERT INTO sales.products(productname,catagory,price,stock)VALUES
('Laptop','Electronics','1200','30'),
('Desk','Furniture','300','50'),
('Chair','Furniture','150','200'),
('Smartphone','Electronics','800','75'),
('Monitor','Electronics','250','40'),
('Bookshief','Furniture','100','60'),
('Printer','Electronics','200','25')

SELECT * FROM sales.products

CREATE Table sales.sales_table(
    SaleID SERIAL PRIMARY KEY,
    ProductID SERIAL REFERENCES sales.products(ProductID) ON DELETE CASCADE,
    EmployeeID SERIAL REFERENCES sales.employee(EmployeeID) ON DELETE CASCADE,
    SalesDate DATE,
    Quantity INT,
    Total DECIMAL (10,2)
);
SELECT * FROM sales.sales_table

INSERT INTO sales.sales_table( productid,employeeid,salesdate,quantity,total)VALUES
('1','1','2021-01-15','2','2400'),
('2','2','2021-03-22','1','300'),
('3','3','2021-05-10','4','600'),
('4','4','2021-07-18','3','2400'),
('5','5','2021-09-25','2','500'),
('6','6','2021-11-30','1','100'),
('7','1','2022-02-10','1','200'),
('1','2','2022-04-10','1','1200'),
('2','3','2022-06-20','2','600'),
('3','4','2022-08-05','3','450'),
('4','5','2022-10-11','1','800'),
('5','6','2022-12-29','4','1000')

SELECT * FROM sales.sales_table

SELECT * FROM sales.employee

SELECT (FristName) FROM sales.employee;

SELECT Departement from sales.employee
WHERE Departement='IT'

SELECT COUNT(*) AS Total FROM sales.employee

SELECT SUM(Salary) AS total_salary FROM sales.employee

SELECT AVG(Salary) AS  Avg_salary FROM sales.employee

SELECT MAX(Salary) As Max_salary FROM sales.employee

SELECT MIN(Salary) As Min_salary FROM sales.employee

SELECT COUNT(*) AS male_employees
FROM sales.employee 
WHERE Gender = 'Male';

SELECT COUNT(*) AS male_employees 
FROM sales.employee
WHERE Gender = 'Female';

SELECT COUNT(*) AS hired_2020 
FROM sales.employee 
WHERE HireDate BETWEEN '2020-01-01' AND '2020-12-31';

SELECT AVG(Salary) AS avg_IT_salary 
FROM  sales.employee 
WHERE Departement = 'IT';

SELECT Departement, COUNT(*) AS num_employees 
FROM sales.employee 
GROUP BY Departement;

SELECT Departement, SUM(Salary) AS total_salary
FROM sales.employee
GROUP BY Departement;

SELECT Departement, MAX(Salary) AS max_salary 
FROM sales.employee 
GROUP BY Departement;

SELECT Departement, MIN(Salary) AS min_salary
 FROM sales.employee
 GROUP BY Departement;

 SELECT Gender, COUNT(*) AS num_employees
 FROM sales.employee
  GROUP BY Gender;

  SELECT Gender, AVG(Salary) AS avg_salary
   FROM sales.employee
   GROUP BY Gender;

   SELECT * FROM sales.employee
   ORDER BY Salary DESC LIMIT 5;

   SELECT COUNT(DISTINCT FristName) AS unique_first
FROM sales.employee E
LEFT JOIN sales_table S ON E.EmployeeID = S.EmployeeID;

 SELECT * FROM sales.employee
 ORDER BY HireDate ASC LIMIT 10;


 SELECT * FROM sales.employee E
LEFT JOIN sales_table S ON E.EmployeeID = S.EmployeeID
WHERE S.SaleID IS NULL;

SELECT EmployeeID, COUNT(*) AS total_sales 
FROM sales_table GROUP BY EmployeeID;

SELECT EmployeeID, SUM(Total) AS total_sales
FROM sales_table
GROUP BY EmployeeID
ORDER BY total_sales DESC
LIMIT 1;

SELECT E.Departement, AVG(S.Quantity) AS avg_quantity
FROM sales.employee E
JOIN sales_table ON E.EmployeeID = S.EmployeeID
GROUP BY E.Departement;

SELECT EmployeeID, SUM(Total) AS total_sales_2021
FROM sales_table
WHERE SalesDate BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY EmployeeID;

SELECT EmployeeID, SUM(Quantity) AS total_quantity
FROM Sales
GROUP BY EmployeeID
ORDER BY total_quantity DESC
LIMIT 3;

SELECT E.Department, SUM(S.Quantity) AS total_quantity
FROM sales.employee E
JOIN Sales S ON E.EmployeeID = S.EmployeeID
GROUP BY E.Department;

SELECT P.Category, SUM(S.Quantity * P.Price) AS total_revenue
FROM sales_table S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;

