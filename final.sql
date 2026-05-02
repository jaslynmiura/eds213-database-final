-- INGEST THE DATABASE --

-- Ingesting the sex count dataset.
CREATE TABLE sex_count AS
SELECT * FROM read_csv_auto('data/df1_cleaned.csv');

-- Ingesting the herd weight dataset.
CREATE TABLE herd_weight AS
SELECT * FROM read_csv_auto('data/df2_cleaned.csv');

-- Ingesting the maternal parentage dataset.
CREATE TABLE maternal_parentage AS
SELECT * FROM read_csv_auto('data/df3_cleaned.csv');

-- View tables in our database.
SELECT * FROM sex_count LIMIT 5;

SELECT * FROM herd_weight LIMIT 5;

SELECT * FROM maternal_parentage LIMIT 5;

-- SEARCH QUERY --

-- Question: Which dams produced the most calves, and what was the average weight of their offspring?
-- (end of season weight)

-- Select 'DamTag' from table mp.
SELECT mp.DamTag,
    -- Count the distinct 'CalfTag' matched to each 'DamTag', as num_calves column.
    COUNT(DISTINCT mp.CalfTag) AS num_calves,
    -- Average 'AnimalWeight' from table hw.
    AVG(hw.AnimalWeight) AS avg_calf_weight
-- Use table mp (maternal_parentage).
FROM maternal_parentage mp
-- Join table hw (herd_weight) on 'CalfTag' table mp and 'AnimalCode' table hw columns.
JOIN herd_weight hw ON mp.CalfTag = hw.AnimalCode
    -- where 'AnimalYOB' in table hw and 'RecYear' in table hw are the same.
    AND hw.AnimalYOB = hw.RecYear
-- Group by 'DamTag' in table mp.
GROUP BY mp.DamTag
-- Order by 'num_calves' from highest to lowest.
ORDER BY num_calves DESC
-- Show the top 20 dams to produce the most calves.
LIMIT 20;

-- Question: What is the average weight of the dams that produce the most calves?
-- Adding a column to the table output, avg_dam_weight.

-- Select 'DamTag' from table mp.
SELECT mp.DamTag,
    -- Count the distinct 'CalfTag' matched to each 'DamTag', as num_calves column.
    COUNT(DISTINCT mp.CalfTag) AS num_calves,
    -- Average 'AnimalWeight' as avg_calf_weight.
    AVG(calf_weight.AnimalWeight) AS avg_calf_weight,
    -- Average 'AnimalWeight' as avg_dam_weight.
    AVG(dam_weight.AnimalWeight) AS avg_dam_weight
-- Use maternal_parentage as mp.
FROM maternal_parentage mp
-- Join calf_weight to table mp, on table mp 'CalfTag' column and table calf_weight 'AnimalCode' column.
JOIN herd_weight calf_weight ON mp.CalfTag = calf_weight.AnimalCode
    -- Where 'AnimalYOB' and 'RecYear' of calf_weight are the same.
    AND calf_weight.AnimalYOB = calf_weight.RecYear
-- Join dam_weight to table mp, on table mp on 'DamTag' column and table dam_weight 'AnimalCode' column.
JOIN herd_weight dam_weight ON mp.DamTag = dam_weight.AnimalCode
-- Group by table mp 'DamTag' column.
GROUP BY mp.DamTag
-- Order by 'num_calves' column from highest to lowest.
ORDER BY num_calves DESC
-- Show the top 20 dams to produce the most calves.
LIMIT 20;


