/* The data I used was originally created as example data for use in Tableau. It is all on one table which causes 
a lot of redundant data that doesn't reflect the needs of managing data and limiting storage use. Before I began 
my queries I decided to normalize the data to better represent real-world examples.*/
CREATE TABLE IF NOT EXISTS original(
row_id int PRIMARY KEY,
order_id text NOT NULL,
order_date date NOT NULL,
ship_date date,
ship_mode text,
customer_id text NOT NULL,
customer_name text NOT NULL,
segment text NOT NULL,
country text NOT NULL,
city text NOT NULL,
"state" text NOT NULL,
postal_code int,
region text NOT NULL,
product_id text NOT NULL,
category text NOT NULL,
sub_category text NOT NULL,
product_name text NOT NULL,
sales decimal(10,5) NOT NULL,
quantity smallint NOT NULL,
discount decimal (3,2) NOT NULL,
profit decimal(10,5) NOT NULL);

COPY original
FROM 'C:\temp\Orders.csv'
DELIMITER ','
CSV HEADER;


/* City, State, postal code, and region are not included in customers table because some customers have 
multiple areas they order from.*/
CREATE TABLE IF NOT EXISTS customers AS
SELECT 
	DISTINCT customer_id,
	customer_name, 
	segment
FROM 
	original;

ALTER TABLE customers 
ADD PRIMARY KEY (customer_id);

/*In the original dataset there were NULL postal codes for Burlington, Vermont that caused issues when
creating the address table. To remedy this issue and because this is only a sample dataset I replaced these
values with the 05401 postal code which is one of five postal codes in the area.*/
UPDATE original
SET postal_code = 05401
WHERE postal_code IS NULL;

CREATE TABLE IF NOT EXISTS address AS
SELECT 
	customer_id ||'-'|| ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY postal_code) AS address_id,
	customer_id, 
	city, 
	"state",
	postal_code,
	region,
	country  
FROM 
	original
GROUP BY 
	customer_name, 
	customer_id, 
	city, 
	"state",
	postal_code,
	region,
	country; 

ALTER TABLE address
ADD PRIMARY KEY(address_id),
ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id);


/*There were a number of alterations made to product id's because in the original data a single id 
referenced multiple products.*/
UPDATE original
SET product_id = 'FUR-FU-10004271'
WHERE product_name = 'Executive Impressions 13" Clairmont Wall Clock';

UPDATE original
SET product_id = 'FUR-FU-10004849'
WHERE product_name = 'DAX Solid Wood Frames';

UPDATE original
SET product_id = 'OFF-ST-10001229'
WHERE product_name = 'Fellowes Personal Hanging Folder Files, Navy';

UPDATE original
SET product_id = 'OFF-ST-10004951'
WHERE product_name = 'Acco Perma 3000 Stacking Storage Drawers';

UPDATE original
SET product_id = 'TEC-AC-10003833'
WHERE product_name = 'Logitech P710e Mobile Speakerphone';

UPDATE original
SET product_id = 'OFF-PA-10002196'
WHERE product_name = 'Xerox 1966';

UPDATE original
SET product_id = 'TEC-PH-10004532'
WHERE product_name = 'AT&T CL2909';

UPDATE original
SET product_id = 'TEC-PH-10001531'
WHERE product_name = 'Plantronics Voyager Pro Legend';

UPDATE original
SET product_id = 'TEC-PH-10001796'
WHERE product_name = 'RCA H5401RE1 DECT 6.0 4-Line Cordless Handset With Caller ID/Call Waiting';

UPDATE original
SET product_id = 'TEC-MA-10001149'
WHERE product_name = 'Okidata MB491 Multifunction Printer';

UPDATE original
SET product_id = 'TEC-PH-10002311'
WHERE product_name = 'Panasonic KX T7731-B Digital phone';

UPDATE original
SET product_id = 'TEC-PH-10002201'
WHERE product_name = 'Samsung Galaxy Note 2';

UPDATE original
SET product_id = 'OFF-PA-10001971'
WHERE product_name = 'Xerox 1908';

UPDATE original
SET product_id = 'TEC-AC-10002050'
WHERE product_name = 'Logitech G19 Programmable Gaming Keyboard';

UPDATE original
SET product_id = 'OFF-AR-10001150'
WHERE product_name = 'Sanford Colorific Colored Pencils, 12/Box';

UPDATE original
SET product_id = 'OFF-PA-10000478'
WHERE product_name = 'Xerox 22';

UPDATE original
SET product_id = 'OFF-BI-10002027'
WHERE product_name = 'Avery Arch Ring Binders';

UPDATE original
SET product_id = 'FUR-CH-10001147'
WHERE product_name = 'Global Task Chair, Black';

UPDATE original
SET product_id = 'OFF-PA-10000660'
WHERE product_name = 'Adams Phone Message Book, Professional, 400 Message Capacity, 5 3/6” x 11”';

UPDATE original
SET product_id = 'OFF-PA-10001167'
WHERE product_name = 'Xerox 1932';

UPDATE original
SET product_id = 'FUR-FU-10001474'
WHERE product_name = 'DAX Wood Document Frame';

UPDATE original
SET product_id = 'FUR-FU-10004016'
WHERE product_name = 'Executive Impressions 13" Chairman Wall Clock';

UPDATE original
SET product_id = 'OFF-PA-10002378'
WHERE product_name = 'Xerox 1916';

UPDATE original
SET product_id = 'TEC-AC-10002551'
WHERE product_name = 'Maxell 4.7GB DVD-RW 3/Pack';

UPDATE original
SET product_id = 'OFF-BI-10004655'
WHERE product_name = 'VariCap6 Expandable Binder';

UPDATE original
SET product_id = 'OFF-BI-10004633'
WHERE product_name = 'GBC Binding covers';

UPDATE original
SET product_id = 'FUR-BO-10002214'
WHERE product_name = 'DMI Eclipse Executive Suite Bookcases';

UPDATE original
SET product_id = 'OFF-PA-10000358'
WHERE product_name = 'Xerox 1888';

UPDATE original
SET product_id = 'OFF-PA-10003023'
WHERE product_name = 'Xerox 1992';

UPDATE original
SET product_id = 'OFF-AP-10000577'
WHERE product_name = 'Belkin 7 Outlet SurgeMaster II';

UPDATE original
SET product_id = 'FUR-FU-10004865'
WHERE product_name = 'Eldon 500 Class Desk Accessories';

UPDATE original
SET product_id = 'FUR-FU-10004092'
WHERE product_name = 'Eldon 200 Class Desk Accessories, Black';

/*There are two products in the dataset with the same name, they have the same sales price but a 
different cost basis. In the original dataset they are considered seperate products so I chose to keep
them seperate instead of averaging the cost.*/
UPDATE original
SET product_id = 'FUR-FU-10000175'
WHERE product_name = 'DAX Wood Document Frame' 
AND 
CAST((sales - profit)/quantity AS decimal(6,2))=9.47;

/* The original data only has sales (revenue), quantity, discount and profit. The sales value
is after the discount is applied so the discount has to be removed to find the actual price of the product.*/  
CREATE TABLE IF NOT EXISTS products AS
SELECT 
	DISTINCT product_id,
	category,
	sub_category,
	product_name,
	CAST((sales/quantity)/(1-discount) AS decimal(6,2)) AS price,
	CAST((sales - profit)/quantity AS decimal(6,2)) AS "cost"
FROM
	original;
	
ALTER TABLE products
ADD PRIMARY KEY (product_id);


/* Address_id is not in the original dataset so this table was joined to get that information.The address 
table is only joined on customer_id and postal_code because postal_code is the lowest level of detail for 
location in this dataset.*/  
CREATE TABLE IF NOT EXISTS orders AS
SELECT
	DISTINCT order_id,
	original.customer_id,
	address_id,
	order_date,
	ship_date,
	ship_mode
FROM
	original
INNER JOIN
	address
	ON
	original.customer_id = address.customer_id
	AND
	original.postal_code = address.postal_code;
	
ALTER TABLE orders
ADD PRIMARY KEY (order_id),
ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
ADD FOREIGN KEY (address_id) REFERENCES address (address_id);


CREATE TABLE IF NOT EXISTS order_items AS
SELECT
	row_id,
	order_id,
	product_id,
	quantity,
	discount
FROM original;

ALTER TABLE order_items
ADD PRIMARY KEY (row_id),
ADD FOREIGN KEY (order_id) REFERENCES orders (order_id),
ADD FOREIGN KEY (product_id) REFERENCES products (product_id);


/*Reconstruction of original dataset as proof of accuracy. There was some slight variance
due to rounding in order to display price and cost as normal two precision decimal types.
See variance file for more information.*/
SELECT 
	row_id,
	o.order_id,
	order_date,
	ship_date,
	ship_mode,
	"c".customer_id,
	customer_name,
	segment,
	country,
	city,
	"state",
	postal_code,
	region,
	"p".product_id,
	category,
	sub_category,
	product_name,
	(price * quantity) * (1-discount) AS sales,
	quantity,
	discount,
	((price * (1 - discount)) - "cost") * quantity AS profit
FROM 
	order_items oi
INNER JOIN
	orders o
	ON
	oi.order_id = o.order_id
INNER JOIN
	products "p"
	ON
	oi.product_id = "p".product_id
INNER JOIN
	customers "c"
	ON
	o.customer_id = "c".customer_id
INNER JOIN 
	address "a"
	ON
	o.address_id = "a".address_id
ORDER BY 
	row_id;


/*With all information successfully extracted from the original dataset it was dropped.*/
DROP TABLE original;