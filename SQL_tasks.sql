use cx360_prab;

# Exploring the Details
select *
from details_intern;

# Exploring the Ratings
select *
from ratings_intern;

# Exploring the Reviews
select *
from reviews_intern;

# The Top 10 Products with the Highest Overall Ratings
SELECT 
    product_id,
    brand,
    rating_overall
FROM 
    ratings_intern
ORDER BY 
    rating_overall DESC
LIMIT 10;


#------------------------------------
# The Distribution of Ratings (1-star to 5-star) for Each Brand
SELECT 
    brand,
    SUM(CASE WHEN review_rating = 1 THEN 1 ELSE 0 END) AS count_1star,
    SUM(CASE WHEN review_rating = 2 THEN 1 ELSE 0 END) AS count_2star,
    SUM(CASE WHEN review_rating = 3 THEN 1 ELSE 0 END) AS count_3star,
    SUM(CASE WHEN review_rating = 4 THEN 1 ELSE 0 END) AS count_4star,
    SUM(CASE WHEN review_rating = 5 THEN 1 ELSE 0 END) AS count_5star
FROM 
    reviews_intern
GROUP BY 
    brand
ORDER BY 
    brand;


#-----------------------------------------
# Identify Products with Below-Average Ratings in Their Respective Categories

SELECT 
    d.product_id, 
    d.product_title,
    d.brand, 
    d.f_category,
    r.rating_overall,
    avg_cat.avg_rating AS category_avg_rating
FROM 
    details_intern d
JOIN 
    ratings_intern r 
ON 
    d.product_id = r.product_id AND d.source = r.source
JOIN 
    (
        -- Subquery to calculate average rating for each category
        SELECT 
            d.f_category, 
            AVG(r.rating_overall) AS avg_rating
        FROM 
            details_intern d
        JOIN 
            ratings_intern r 
        ON 
            d.product_id = r.product_id AND d.source = r.source
        GROUP BY 
            d.f_category
    ) avg_cat
ON 
    d.f_category = avg_cat.f_category
WHERE 
    r.rating_overall < avg_cat.avg_rating
ORDER BY 
    d.f_category, r.rating_overall;


#------------------------------------
# Create a View Summarizing Weekly Trends in Review Counts
CREATE VIEW weekly_review_trends AS
SELECT 
    review_week,
    COUNT(reviews_id) AS review_count
FROM 
    reviews_intern
GROUP BY 
    review_week
ORDER BY 
    review_week;

#------------------------------------
