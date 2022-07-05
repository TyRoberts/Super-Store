SELECT 
	TO_CHAR("month", 'Mon-YY') AS "Month",
	"Furniture",
	"Office Supplies",
	"Technology"
FROM crosstab(
	$$ SELECT
		DATE_TRUNC('month', order_date) AS "month",
		category,
		TO_CHAR(SUM(((price * (1 - discount)) - "cost") * quantity), 'L999G999PR') AS profit
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
	WHERE address_id LIKE '67-%' --67 represents Central region
	GROUP BY 
		"month",
		category 
	ORDER BY 
		"month",
		category $$,
	$$ VALUES 
		('Furniture'::text),
		('Office Supplies'::text),
		('Technology'::text)$$ 
) AS ct (
		"month" timestamp with time zone,
		"Furniture" text, 
		"Office Supplies" text, 
		"Technology" text
			)
ORDER BY 
	ct."month";