SELECT
	region AS "Region",
	customer_name AS "Customer Name",
	COUNT(pr.product_id) AS "Orders",
	city AS "City",
	"state" AS "State",
	TO_CHAR(MAX(order_date), 'DD-Mon-YY') AS "Last Order On",
	TO_CHAR(SUM((price * quantity) * (1-discount)), 'L999G990D99')  AS "Sales",
	TO_CHAR(SUM(((price * (1 - discount)) - "cost") * quantity * 100) / 
			SUM((price * quantity) * (1-discount)), 'FM999%')  AS "Profit Ratio",
	SUM(ship_date - order_date) AS "Days to Ship",
	SUM(quantity) AS "Quantity"
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
	address ad
	ON
	o.address_id = ad.address_id
INNER JOIN
	customers cu
	ON
	o.customer_id = cu.customer_id
GROUP BY 
	region,
	customer_name,
	city,
	"state"
ORDER BY 
	"Sales";