SELECT
	"Sub-Category",
	"Central",
	"East",
	"South",
	"West"
FROM crosstab(
	$$ SELECT 
		sub_category,
		region,
		TO_CHAR(SUM((price * quantity) * (1 - discount)), 'L999G999') AS sales
	FROM
		order_items
	INNER JOIN
		orders 
		ON
		order_items.order_id = orders.order_id
	INNER JOIN
		products 
		ON
		order_items.product_id = products.product_id
	INNER JOIN
		address
		ON
		orders.address_id = address.address_id
	GROUP BY 
		sub_category,
		region
	ORDER BY
		sub_category,
		region $$,
	$$ VALUES
		('Central'::text),
		('East'::text),
		('South'::text),
		('West'::text) $$
) AS ct (
		"Sub-Category" text,
		"Central" text,
		"East" text,
		"South" text,
		"West" text)
ORDER BY 
	"Sub-Category";