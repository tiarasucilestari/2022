-- Memahami table
Sebelum memulai menyusun query SQL dan membuat Analisa dari hasil query, hal pertama yang perlu dilakukan adalah menjadi familiar dengan tabel yang akan digunakan. Hal ini akan sangat berguna dalam menentukan kolom mana sekiranya berkaitan dengan problem yang akan dianalisa, dan proses manipulasi data apa yang sekiranya perlu dilakukan untuk kolom – kolom tersebut, karena tidak semua kolom pada tabel perlu untuk digunakan.
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;


--Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
SELECT  
SUM(quantity) AS total_penjualan,
SUM(quantity * priceEach) AS revenue
FROM orders_1
WHERE status = "Shipped";

SELECT 
SUM(quantity) AS total_penjualan,
SUM(quantity * priceEach) AS revenue
FROM orders_2
WHERE status = "Shipped";

--Menghitung persentasi keseluruhan penjualan
SELECT quarter, SUM(quantity) AS total_penjualan, SUM(quantity * priceeach) AS revenue FROM 
(
SELECT 
orderNumber,status,quantity,priceeach,"1" as quarter FROM orders_1 
UNION 
SELECT orderNumber,status,quantity,priceeach,"2" as quarter FROM orders_2) AS tabel_a
WHERE
status="Shipped"
GROUP BY
quarter ;


--Apakah jumlah customers xyz.com semakin bertambah?

SELECT quarter, COUNT(DISTINCT customerID) as total_customers
FROM 
(
 SELECT customerID, createDate, QUARTER(createDate) AS quarter 
 FROM customer
 WHERE
 createDate BETWEEN '2004-01-01' AND '2004-06-30' ) 
 AS tabel_b
 GROUP BY 
 quarter;

--Seberapa banyak customers tersebut yang sudah melakukan transaksi?

SELECT 
quarter, COUNT(DISTINCT customerID) AS total_customers
FROM
(
SELECT
customerID,createDate,QUARTER(createDate) AS quarter
FROM customer
WHERE 
createDate BETWEEN '2004-01-01' and '2004-06-30' ) AS tabel_b
WHERE 
customerID in (select DISTINCT customerID from orders_1
UNION 
SELECT DISTINCT customerID FROM orders_2) 
GROUP BY quarter;

--Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?

SELECT * FROM
(
SELECT
 categoryID, count(distinct orderNumber) AS total_order,
 SUM(quantity) as total_penjualan FROM
 (
 select 
 productCode,
 orderNumber,
 quantity,
 status,
 LEFT(productCode,3) AS categoryID
 FROM 
 orders_2
  WHERE 
  status ='Shipped'
) tabel_c
 group by 
 categoryID ) A
 ORDER BY
 total_order DESC;

--Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
--Menghitung total unik customers yang transaksi di quarter_1

SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;

--output = 25

select "1" AS quarter,
(COUNT(DISTINCT customerID) * 100)/ 25 AS Q2
FROM
orders_1
WHERE
customerID IN(
SELECT
DISTINCT customerID
from
orders_2 );



