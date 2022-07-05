SELECT
	"state" AS "State",
	region AS "Region",
	TO_CHAR(SUM((price * quantity) * (1 - discount)), 'L999G999') AS "Sales"
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