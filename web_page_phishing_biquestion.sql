-- Data exploration focused on data correlation between Phishing column and the rest of the data
-- 1
SELECT phishing, SUM(n_slash) FROM web_page_phishing w
INNER JOIN phishing_dataset p ON p.unique_id = w.unique_id
GROUP BY phishing;

-- 2

SELECT
    corr(phishing, n_slash) AS correlacion_con_url
FROM
    web_page_phishing w
JOIN phishing_dataset p ON p.unique_id = w.unique_id; 

-- 3

SELECT
    corr(phishing, n_questionmark) AS correlacion_con_url
FROM
    web_page_phishing w
JOIN phishing_dataset p ON p.unique_id = w.unique_id
	WHERE n_questionmark <> phishing AND w.unique_id <> phishing AND p.unique_id <> phishing; 

-- 4

SELECT unique_id, url_length, phishing FROM web_page_phishing
ORDER BY url_length;

-- 5

SELECT url_length, phishing,
	CASE WHEN phishing = 0 THEN 'Legit' ELSE 'Phishing' END AS resultado FROM web_page_phishing
ORDER BY url_length;

-- 6

SELECT phishing, COUNT(phishing) phishing_total FROM web_page_phishing
WHERE url_length < 50
GROUP BY phishing;

-- 7

SELECT phishing, CASE
	WHEN url_length BETWEEN 0 AND 299 THEN '1-299'
	WHEN url_length BETWEEN 300 AND 599 THEN '300-599'
	WHEN url_length BETWEEN 600 AND 899 THEN '600-899'
	WHEN url_length BETWEEN 900 AND 1199 THEN '900-1199'
	ELSE '1200+'
END AS range_group, COUNT(phishing)
FROM web_page_phishing
GROUP BY phishing, range_group
ORDER BY range_group ASC;

-- 8

SELECT url_length, n_redirection, phishing, n_slash, n_equal FROM web_page_phishing w
INNER JOIN phishing_dataset p ON p.unique_id = w.unique_id
WHERE n_slash > 1 AND n_slash > 1 AND n_equal > 1
ORDER BY n_redirection DESC, n_slash DESC;

-- 9

SELECT CASE WHEN phishing = 0 THEN 'Legit' ELSE 'Phishing' END AS phishing, n_redirection, COUNT(n_redirection) AS redirection_phishing_count
FROM web_page_phishing
GROUP BY phishing, n_redirection
ORDER BY n_redirection desc, redirection_phishing_count DESC;

-- 10

SELECT
    corr(phishing, url_length) AS correlacion_con_url,
    corr(phishing, n_slash) AS correlacion_con_slash,
    corr(phishing, n_dots) AS correlacion_con_dots,
    corr(phishing, n_redirection) AS correlacion_con_redirecciones
FROM
    web_page_phishing w
JOIN phishing_dataset p ON p.unique_id = w.unique_id;

-- 10 

SELECT
    Phishing,
    ROUND(AVG(url_length),3) AS media_url_length,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY url_length) AS mediana_url_length
FROM
    web_page_phishing
GROUP BY
    Phishing;

ALTER TABLE web_page_phishing
ALTER COLUMN phishing TYPE BOOLEAN USING phishing::BOOLEAN;

-- 11 

SELECT
    CORR(phishing, url_length) AS correlacion_url_length,
    CORR(phishing, n_dots) AS correlacion_n_dots,
    CORR(phishing, n_hyphens) AS correlacion_n_hyphens,
    CORR(phishing, n_underline) AS correlacion_n_underline,
    CORR(phishing, n_slash) AS correlacion_n_slash,
    CORR(phishing, n_questionmark) AS correlacion_n_questionmark,
    CORR(phishing, n_equal) AS correlacion_n_equal,
    CORR(phishing, n_at) AS correlacion_n_at,
    CORR(phishing, n_and) AS correlacion_n_and,
    CORR(phishing, n_exclamation) AS correlacion_n_exclamation,
    CORR(phishing, n_space) AS correlacion_n_space,
    CORR(phishing, n_tilde) AS correlacion_n_tilde,
    CORR(phishing, n_comma) AS correlacion_n_comma,
    CORR(phishing, n_plus) AS correlacion_n_plus,
    CORR(phishing, n_asterisk) AS correlacion_n_asterisk,
    CORR(phishing, n_hashtag) AS correlacion_n_hashtag,
    CORR(phishing, n_dollar) AS correlacion_n_dollar,
    CORR(phishing, n_percent) AS correlacion_n_percent,
    CORR(phishing, n_redirection) AS correlacion_n_redirection
FROM
    web_page_phishing w
INNER JOIN phishing_dataset p ON p.unique_id = w.unique_id;

