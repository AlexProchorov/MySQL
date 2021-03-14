DROP FUNCTION IF EXISTS g_relevancy;
DELIMITER //
CREATE FUNCTION g_relevancy(t_id INT UNSIGNED, g_id INT UNSIGNED)
	RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT likes.c - dislikes.c
	FROM (SELECT count(vote) AS c FROM votes_on_genre
	WHERE vote = 1 AND title_id = t_id AND genre_id = g_id) AS likes
	JOIN (SELECT count(vote) AS c FROM votes_on_genre
	WHERE vote = 0 AND title_id = t_id AND genre_id = g_id) AS dislikes);
END;
//
DELIMITER ;




DROP FUNCTION IF EXISTS review_rate;
DELIMITER //
CREATE FUNCTION review_rate(r_id INT UNSIGNED)
	RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT likes.c - dislikes.c
	FROM (SELECT count(vote) AS c FROM votes_on_reviews
	WHERE vote = 1 AND review_id = r_id) AS likes
	JOIN (SELECT count(vote) AS c FROM votes_on_reviews
	WHERE vote = 0 AND review_id = r_id) AS dislikes);
END;
//
DELIMITER ;