USE vk;

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	target_id INT UNSIGNED NOT NULL,
	terget_type_id INT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);
	
INSERT INTO target_types (name) VALUES
	('messages'),
	('users'),
	('media'),
	('posts');

select * from target_types;
select * from likes;
select * from messages;

INSERT INTO likes
	SELECT 
	 id,
	 FLOOR(1+(RAND()*100)),
	 FLOOR(1+(RAND()*100)),
	 FLOOR(1+(RAND()*4)),
	 CURRENT_TIMESTAMP FROM messages; 
	
ALTER TABLE profiles 
	ADD CONSTRAINT profiles_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;
	
ALTER TABLE messages 
	ADD CONSTRAINT messages_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
			ON DELETE CASCADE;		
ALTER TABLE messages 
	ADD CONSTRAINT messages_to_user_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
			ON DELETE CASCADE;	
		
		
SELECT  * FROM communities ;	
		
		
ALTER TABLE communities 
	ADD CONSTRAINT communities_communities_users_fk
		FOREIGN KEY (id) REFERENCES communities_users(community_id)
			ON DELETE CASCADE;	
	
	

ALTER TABLE friendship 
	ADD CONSTRAINT friendship_from_user_id_fk
		FOREIGN KEY (friend_id) REFERENCES users(id)
			ON DELETE CASCADE;	
		
		
ALTER TABLE friendship 
	ADD CONSTRAINT friendship_to_userr_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;	
			
		
-- 3 задание 

		

			
SELECT concat(if(men_>all_/2, 'Мужчины', 'Женщины'),' поставили больше Лайков') AS ansver FROM 
(SELECT 
  (SELECT count(*) FROM likes WHERE 
    user_id IN (SELECT user_id FROM profiles WHERE gender = 'M')) AS men_,
  (SELECT count(*) FROM likes) AS all_) AS total;
			
    -- 4 hw
			
	SELECT COUNT(target_id) FROM likes 
			WHERE user_id  IN 
		(SELECT * FROM(SELECT user_id  FROM profiles ORDER BY birthday LIMIT 10)AS TTT);
	
-- 5 hw

	SELECT user_id,target_id FROM likes WHERE target_id ORDER BY target_id LIMIT 10;

