select * from users;
desc users;

DROP TABLE IF EXISTS users_updating;
create table users_updating (
 	Id serial primary key,
 	users_name VARCHAR (55),
 	update_email VARCHAR(100),
 	updating_phone bigint unsigned,
 	signed_up_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP);
 
 delimiter //
 
 CREATE TRIGGER users_updating 
 	after update on users
 	for EACH ROW 
 	begin 
	 	insert into users_updating  (id,users_name,update_email,updating_phone)
	 	values(id, NEW.username,NEW.email,NEW.phone_number);
 	end//
 	
 update users 
 	set username = 'Aleeeex'
 	where id = 1;
 	
 	