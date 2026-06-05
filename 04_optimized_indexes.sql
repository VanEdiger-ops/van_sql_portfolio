
/*
================================================================================
Database Performance Tuning Case Study - Index Benchmarking
================================================================================
Target System: Microsoft SQL Server (T-SQL)
Description: Indexing experiments on a high-volume dataset (100,000+ records) 
             tracking ship movements through the Suez Canal.
*/

-- -----------------------------------------------------------------------------
-- 1. DATA GENERATION FOR PERFORMANCE TESTING
-- -----------------------------------------------------------------------------

CREATE TABLE vessel_transits (
    transit_id     INT PRIMARY KEY,
    vessel_id      INT,
    vessel_type    VARCHAR(50),
    transit_date   DATE,
    cargo_type     VARCHAR(50),
    cargo_volume   DECIMAL(12,2)
);
GO

-- Populate table with 100,000 mock records using a loop to test index efficiency
DECLARE @i INT = 1;

WHILE @i <= 100000
BEGIN
	INSERT INTO vessel_transits (transit_id, vessel_id, vessel_type, transit_date, cargo_type, cargo_volume)
	VALUES (
		@i, 
		(@i % 5000) + 1,
		CASE 
			WHEN @i % 4 = 0 THEN 'Oil Tanker'
			WHEN @i % 4 = 1 THEN 'Container Ship'
			WHEN @i % 4 = 2 THEN 'LNG Carrier'
			ELSE 'Bulk Carrier'
		END,
		DATEADD(DAY, -(@i % 1000), GETDATE()),
		CASE 
			WHEN @i % 4 = 0 THEN 'Crude Oil'
			WHEN @i % 4 = 1 THEN 'Consumer Goods'
			WHEN @i % 4 = 2 THEN 'Liquefied Natural Gas'
			ELSE 'Grain'
		END,
		CASE 
			WHEN @i % 4 = 0 THEN 50000 + (@i % 20000)
			WHEN @i % 4 = 1 THEN 10000 + (@i % 5000)
			WHEN @i % 4 = 2 THEN 30000 + (@i % 10000)
			ELSE 15000 + (@i % 7000)
		END
	);

    SET @i = @i + 1;
END;
GO

-- Verify total row count
SELECT		COUNT(*) FROM vessel_transits;
GO


-- -----------------------------------------------------------------------------
-- 2. BENCHMARK TESTS & EXECUTION TIMES
-- -----------------------------------------------------------------------------

-- Enable time tracking to measure query speed
SET STATISTICS TIME ON;
GO

-- Test 1: Baseline search with no indexes (forces a full table scan)
SELECT		* FROM		vessel_transits 
WHERE		vessel_id = 5000;
-- Benchmark Results: CPU time = 16 ms, Elapsed time = 13 ms.
GO


-- Test 2: Search with a dedicated single-column index
CREATE INDEX idx_vessel_id ON vessel_transits (vessel_id);
GO

SELECT		* FROM		vessel_transits 
WHERE		vessel_id = 5000;
-- Benchmark Results: CPU time = 0 ms, Elapsed time = 0 ms.
GO


-- Test 3: Large date range query before creating a date index
SELECT		* FROM		vessel_transits 
WHERE		transit_date BETWEEN '2023-01-01' AND '2023-12-31';
-- Benchmark Results: CPU time = 15 ms, Elapsed time = 154 ms.
GO


-- Test 4: Re-running date range query after creating a single-column index
CREATE INDEX idx_transit_date ON vessel_transits (transit_date);
GO

SELECT		* FROM		vessel_transits 
WHERE		transit_date BETWEEN '2023-01-01' AND '2023-12-31';
/* Benchmark Results Across Multiple Runs:
   - Run 1: CPU time = 15 ms, Elapsed time = 112 ms.
   - Run 2: CPU time = 31 ms, Elapsed time = 147 ms.
   - Run 3: CPU time = 32 ms, Elapsed time = 252 ms.
   - Run 4: CPU time = 16 ms, Elapsed time = 137 ms.
   Note: Performance varied wildly and sometimes slowed down, making this index unreliable for this wide range.
*/
GO


-- Test 5: Re-running multi-filter query with a composite (multi-column) index
CREATE INDEX idx_vessel_transit_date ON vessel_transits (vessel_id, transit_date);
GO

SELECT		* FROM		vessel_transits 
WHERE		vessel_id = 5000 AND transit_date > '2023-01-01';
/* Benchmark Results Across Multiple Runs:
   - Run 1: CPU time = 0 ms,  Elapsed time = 134 ms.
   - Run 2: CPU time = 32 ms, Elapsed time = 148 ms.
   - Run 3: CPU time = 32 ms, Elapsed time = 158 ms.
   - Run 4: CPU time = 0 ms,  Elapsed time = 116 ms.
*/
GO


-- -----------------------------------------------------------------------------
-- 3. PERFORMANCE ANALYSIS
-- -----------------------------------------------------------------------------

/*
1. Which index provided the greatest performance improvement?
The single-column index on vessel_id for exact lookups provided the cleanest speedup (dropping to 0ms), 
but the composite index (vessel_id, transit_date) gave the best improvement for multi-filter queries. 
Because the query narrows down the data by an exact ID first, the database engine can quickly isolate 
those matching rows and then immediately check the dates within that tiny subset.

2. Why does indexing vessel_id significantly impact equality searches?
An exact match lookup (= 5000) benefits perfectly from a B-Tree index. Instead of checking all 
100,000 rows from top to bottom, the index works like a book index, pointing the database straight 
to the exact location of those specific rows, which completely eliminates unnecessary scanning.

3. How does the index on transit_date help (or not help) with range queries?
A date index helps if you are looking for a very narrow window (like a single day or week). However, 
when a query asks for a massive date range (like an entire year), the index stops being helpful. 
The database engine realizes it has to pull a massive percentage of the total rows anyway, so it 
often skips using the index entirely or jumps back and forth, causing erratic execution times.

4. Why is the order of columns important in a composite index?
The column order determines how the index sorts and filters the data. You want the most specific, 
exact-match filter (like vessel_id) as the very first column. This allows the database engine to 
instantly slice away 99% of the table on step one, leaving a tiny pile of data for the second column 
(transit_date) to sort through.

5. In the context of maritime monitoring in the Suez canal, what types of queries would benefit most from indexing?
Queries that track heavy day-to-day patterns or congestion bottlenecks will benefit the most. 
For example, running frequent searches on specific ship types (like oil tankers) or tracking active travel 
history during peak traffic seasons allows operators to spot trends, predict crossing delays, and schedule 
safer windows for high-priority or high-risk cargo shipments.
*/