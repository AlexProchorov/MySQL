CREATE OR REPLACE VIEW countries_info AS
	SELECT c.id as c_id,
		   c.country,
		   tc.c1 AS all_titles,
		   up.c2 AS all_users,
		   cr.c3 AS all_creators
	  FROM countries c
	LEFT JOIN (SELECT count(title_id) AS c1,country_id
			FROM title_country
			GROUP BY country_id) AS tc ON c.id = tc.country_id
	LEFT JOIN (SELECT count(user_id) AS c2,country_id
	FROM user_profiles GROUP BY country_id) AS up ON c.id = up.country_id
	lEFT JOIN (SELECT count(id) AS c3, country_id
	FROM creators
	GROUP BY country_id) AS cr ON c.id = cr.country_id
	 ORDER BY
		 c.country;
		

CREATE OR REPLACE VIEW titles_and_companies AS
	SELECT t.id AS t_id,
		   t.title,
		   c.id AS comp_id,
		   c.company
	FROM titles t
	JOIN title_company tc ON t.id = tc.title_id
	JOIN companies c ON tc.company_id = c.id
	ORDER BY
		 t.id;
		





