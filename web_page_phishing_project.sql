-- Create webphisingraw table and then import table

DROP TABLE IF EXISTS public.webphisingraw;

CREATE TABLE IF NOT EXISTS public.webphisingraw
(
    url_length integer,
    n_dots integer,
    n_hypens integer,
    n_underline integer,
    n_slash integer,
    n_questionmark integer,
    n_equal integer,
    n_at integer,
    n_and integer,
    n_exclamation integer,
    n_space integer,
    n_tilde integer,
    n_comma integer,
    n_plus integer,
    n_asterisk integer,
    n_hastag integer,
    n_dollar integer,
    n_percent integer,
    n_redirection integer,
    phishing integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.webphisingraw
    OWNER to postgres;


-- Browse the data in the imported table

SELECT * FROM webphisingraw;

-- Create the first table of the new template, called web_page_phishing

DROP TABLE IF EXISTS public.web_page_phishing;

CREATE TABLE IF NOT EXISTS public.web_page_phishing
(
    unique_id SERIAL PRIMARY KEY,
	url_length integer,
	n_redirection integer,
	phishing integer
	
);

SELECT * FROM web_page_phishing;

-- Insert data to the web_page_phishing table through an INSERT INTO + SELECT

INSERT INTO web_page_phishing (url_length, n_redirection, phishing)
SELECT url_length, n_redirection, phishing FROM webphisingraw;

-- Select new table to check that everything is ok

SELECT * FROM web_page_phishing;

-- Create second table of the model, called phishing_dataset

CREATE TABLE IF NOT EXISTS public.phishing_dataset
(	unique_id SERIAL,
    n_dots INTEGER,
    n_hyphens INTEGER,
    n_underline INTEGER,
    n_slash INTEGER,
    n_questionmark INTEGER,
    n_equal INTEGER,
    n_at INTEGER,
    n_and INTEGER,
    n_exclamation INTEGER,
    n_space INTEGER,
    n_tilde INTEGER,
    n_comma INTEGER,
    n_plus INTEGER,
    n_asterisk INTEGER,
    n_hashtag INTEGER,
    n_dollar INTEGER,
    n_percent INTEGER
);

SELECT * FROM phishing_dataset;

-- Insert data to the table with INSERT INTO + SELECT

INSERT INTO phishing_dataset (n_dots, n_hyphens, n_underline, 
	n_slash, n_questionmark, n_equal, n_at, n_and, n_exclamation, 
	n_space, n_tilde, n_comma, n_plus, n_asterisk, n_hashtag, n_dollar, n_percent)
	
SELECT n_dots, n_hypens, n_underline, 
	n_slash, n_questionmark, n_equal, n_at, n_and, n_exclamation, 
	n_space, n_tilde, n_comma, n_plus, n_asterisk, n_hastag, n_dollar, n_percent
FROM webphisingraw;

-- Use some JOIN types to test the functionality of the relationships

SELECT w.unique_id, url_length, n_dots FROM web_page_phishing w
JOIN phishing_dataset p ON w.unique_id = p.unique_id
WHERE n_dots > 20;

-- Develop a JOIN query that selects the first 1000 rows filtered by the columns url_length, and sorted by n_slash, n_at and n_and

SELECT w.unique_id, w.url_length, p.n_dots, p.n_hyphens, p.n_underline, 
	p.n_slash, p.n_at, p.n_and, p.n_percent, w.phishing FROM web_page_phishing w
JOIN phishing_dataset p ON w.unique_id = p.unique_id
WHERE w.url_length > 150
ORDER BY w.url_length DESC
LIMIT 1000;

-- Create VIEW with filtered dataset

CREATE VIEW web_p_view AS
SELECT w.unique_id, w.url_length, p.n_dots, p.n_hyphens, p.n_underline, 
	p.n_slash, p.n_at, p.n_and, p.n_percent, w.phishing FROM web_page_phishing w
JOIN phishing_dataset p ON w.unique_id = p.unique_id
WHERE w.url_length > 150
ORDER BY w.url_length DESC
LIMIT 1000;

-- SELECT VIEW

SELECT * FROM web_p_view;