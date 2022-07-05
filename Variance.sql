/*Reconstruction of original dataset as proof of accuracy. There was some slight variance
due to rounding done to display price and cost in a normal two decimal fashion.
Given the variance the trade-off was accepatable. See variance below.*/
SELECT 
	row_id,
	o.order_id,
	order_date,
	ship_date,
	ship_mode,
	cu.customer_id,
	customer_name,
	segment,
	country,
	city,
	"state",
	postal_code,
	region,
	pr.product_id,
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
	products pr 
	ON
	oi.product_id = pr.product_id
INNER JOIN
	customers cu
	ON
	o.customer_id = cu.customer_id
INNER JOIN 
	address ad
	ON
	o.address_id = ad.address_id
ORDER BY 
	row_id;


/*Average variance of profit = -.0010*/
WITH norm AS(SELECT 
	row_id,
	(((price * (1 - discount)) - "cost") * quantity) AS profit
FROM 
	order_items oi
INNER JOIN
	orders o
	ON
	oi.order_id = o.order_id
INNER JOIN
	products pr
	ON
	oi.product_id = pr.product_id)
	
SELECT
	AVG(o.profit - n.profit)
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;


/*No Variance for sales.*/
WITH norm AS(SELECT 
	row_id,
	(price * quantity) * (1-discount) AS sales
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
	AVG(o.sales - n.sales)
FROM
	original o
INNER JOIN
	norm n
	ON
	o.row_id = n.row_id;


/*After variance check there was no need for the original dataset, it was dropped.*/
DROP TABLE original;