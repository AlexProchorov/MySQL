DROP DATABASE IF EXISTS move_for_you;
CREATE DATABASE move_for_you;
USE move_for_you;
-- ---------------------------------------------------

DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
	ID SERIAL PRIMARY KEY AUTO_INCREMENT,
	Company VARCHAR(255) UNIQUE NOT NULL); 

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
	id SERIAL PRIMARY KEY AUTO_INCREMENT,
	country VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
	id SERIAL PRIMARY KEY,
	genre VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
	id SERIAL PRIMARY KEY,
	role VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS title_types;
CREATE TABLE title_types (
	id SERIAL PRIMARY KEY,
	title_type VARCHAR(200) UNIQUE NOT NULL);

-- Table for USERS
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	signed_up_at TIMESTAMP DEFAULT now(),
	username VARCHAR(50) UNIQUE,
	email VARCHAR(100) UNIQUE,
	phone_number BIGINT UNSIGNED UNIQUE,
	password_hash VARCHAR(100)
);
DROP TABLE IF EXISTS user_profiles;
CREATE TABLE user_profiles (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	updated_at TIMESTAMP DEFAULT now(),
	avatar BIGINT UNSIGNED DEFAULT 1,
	first_name VARCHAR(100) DEFAULT ' ',
	last_name VARCHAR(100) DEFAULT ' ',
	gender ENUM ('m', 'f', 'nb', 'ud') DEFAULT 'ud',
	date_of_birth DATE,
	country_id BIGINT UNSIGNED,
	about VARCHAR(350) DEFAULT ' ',
	is_private BIT DEFAULT 0);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user BIGINT UNSIGNED,
	to_user BIGINT UNSIGNED,
	created_at TIMESTAMP DEFAULT now(),
	body_text TEXT NOT NULL);


-- RELATIONSHIP BETWEEN TABLES

CREATE INDEX user_name_idx on user_profiles (first_name,last_name);

ALTER TABLE user_profiles 
ADD CONSTRAINT user_profiles_fk
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE;
ALTER TABLE user_profiles 
ADD CONSTRAINT country_profiles_id
	FOREIGN KEY (country_id) REFERENCES countries (id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE;

ALTER TABLE messages
ADD CONSTRAINT from_user_id_fk
	FOREIGN KEY (from_user) REFERENCES users (id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE;

ALTER TABLE messages
ADD CONSTRAINT to_user_id_fk
	FOREIGN KEY (to_user) REFERENCES users (id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE;
	

-- Titles information

DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	original_title VARCHAR(100) DEFAULT ' ',
	INDEX (title),
	INDEX (original_title)
);

DROP TABLE IF EXISTS title_info;
CREATE TABLE title_info (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	title_type_id BIGINT UNSIGNED DEFAULT 1,
	poster BIGINT UNSIGNED DEFAULT 2,
	tagline VARCHAR(200) DEFAULT ' ',
	synopsis VARCHAR(500) DEFAULT ' ',
	release_date DATE,
	rars ENUM ('0+', '6+', '12+', '16+', '18+', 'NR') DEFAULT 'NR',
	INDEX (release_date));


-- -- RELATIONSHIP BETWEEN TABLES

ALTER TABLE title_info
ADD CONSTRAINT title_info_id_fk
	FOREIGN KEY (title_id) REFERENCES titles(id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE;
alter table title_info 
add constraint
	FOREIGN KEY (title_type_id) REFERENCES title_types (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE;

-- Titles additional

	DROP TABLE IF EXISTS title_country;
CREATE TABLE title_country (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	country_id BIGINT UNSIGNED,
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (country_id) REFERENCES countries (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS title_company;
CREATE TABLE title_company (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	company_id BIGINT UNSIGNED,
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (company_id) REFERENCES companies (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS creators;
CREATE TABLE creators (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(200),
	last_name VARCHAR(200),
	date_of_birth DATE,
	date_of_death DATE DEFAULT NULL,
	gender ENUM ('m', 'f', 'nb', 'ud') DEFAULT 'ud',
	photo BIGINT UNSIGNED,
	country_id BIGINT UNSIGNED,
	INDEX creator_name_idx (first_name, last_name),
	FOREIGN KEY (country_id) REFERENCES countries (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS cast_and_crew;
CREATE TABLE cast_and_crew (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	role_id BIGINT UNSIGNED,
	creator_id BIGINT UNSIGNED,
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (role_id) REFERENCES roles (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (creator_id) REFERENCES creators (id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);
-- ----------------------- TITLES INFO, INFLUENCED BY USERS
DROP TABLE IF EXISTS all_keywords;
CREATE TABLE all_keywords (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	keyword VARCHAR(100) UNIQUE,
	created_at TIMESTAMP DEFAULT now(),
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS votes_on_keywords;
CREATE TABLE votes_on_keywords (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	keyword_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED,
	vote BIT DEFAULT 1,
	created_at TIMESTAMP DEFAULT now(),
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (keyword_id) REFERENCES all_keywords (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS votes_on_genre;
CREATE TABLE votes_on_genre (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	genre_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED,
	vote BIT,
	created_at TIMESTAMP DEFAULT now(),
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES genres (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	user_id BIGINT UNSIGNED,
	rating TINYINT UNSIGNED NOT NULL DEFAULT 0,
	created_at TIMESTAMP DEFAULT now(),
	updated_at TIMESTAMP DEFAULT now(),
	INDEX (rating),
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
	id SERIAL PRIMARY KEY,
	title_id BIGINT UNSIGNED,
	user_id BIGINT UNSIGNED,
	body VARCHAR(500),
	is_positive BIT DEFAULT 1,
	created_at TIMESTAMP DEFAULT now(),
	INDEX (is_positive),
	FOREIGN KEY (title_id) REFERENCES titles (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS votes_on_reviews;
CREATE TABLE votes_on_reviews (
	id SERIAL PRIMARY KEY,
	review_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED,
	vote BIT,
	created_at TIMESTAMP DEFAULT now(),
	FOREIGN KEY (review_id) REFERENCES reviews (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);






