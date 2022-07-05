SELECT
	"state" AS "State",
	region AS "Region",
	TO_CHAR(SUM(((price * (1 - discount)) - "cost") * quantity), 'L999G999PR') AS "Profit"
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
GROUP BY 
	region,
	"state"
ORDER BY 
	"state";