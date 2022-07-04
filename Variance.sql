/*Max variance of profit = .0700*/
WITH norm AS(SELECT 
	row_id,
	(price * quantity) * (1-discount) AS sales,
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
	oi.product_id = "p".product_id)
	
SELECT
	MAX(o.profit - n.profit)
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;


/*Average variance of profit = -.0010*/
WITH norm AS(SELECT 
	row_id,
	(price * quantity) * (1-discount) AS sales,
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
	oi.product_id = "p".product_id)
	
SELECT
	AVG(o.profit - n.profit)
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;


/*No Variance of sales.*/
WITH norm AS(SELECT 
	row_id,
	(price * quantity) * (1-discount) AS sales,
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
	oi.product_id = "p".product_id)
	
SELECT
	MAX(ABS(o.sales - n.sales))
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;

WITH norm AS(SELECT 
	row_id,
	(price * quantity) * (1-discount) AS sales,
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
	oi.product_id = "p".product_id)
	
SELECT
	AVG(ABS(o.sales - n.sales))
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;