SELECT 
	category AS "Category",
	"Central",
	"East",
	"South",
	"West"
FROM crosstab(
	$$ SELECT
		CASE WHEN category IS NULL THEN '*Total'
		ELSE category END,
		region,
		TO_CHAR(SUM(price * discount * quantity), 'L999G999') AS discount
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
		ROLLUP(category)
	ORDER BY 
		category,
		region $$,
	$$ VALUES
		('Central'::text),
		('East'::text),
		('South'::text),
		('West'::text) $$
) AS discount (
		"category" text,
		"Central" text,
		"East" text,
		"South" text,
		"West" text
		)
ORDER BY 
	category;