# van_sql_portfolio
Relational database project featuring a 50-table schema, 3NF normalization, optimized indexes, triggers, and transactional rollbacks.

# Relational Database Engineering & Performance Optimization Portfolio

A collection of enterprise-grade database solutions demonstrating expertise in relational database architecture, advanced SQL programmability, performance optimization, and role-based access control (RBAC).

---

## Core Technical Proficiencies
*   **Database Engines:** Microsoft SQL Server (T-SQL), MySQL
*   **Data Modeling:** 3NF Normalization, Schema Architecture, Relational Algebra, Entity-Relationship Diagrams (ERD)
*   **Advanced Programmability:** Stored Procedures, ACID Transactions, Complex Database Triggers (BEFORE/AFTER/INSTEAD OF)
*   **Performance Tuning:** Execution Plan Analysis, Composite Indexing, Query Optimization, Benchmarking
*   **Data Security:** Role-Based Access Control (RBAC), Least Privilege Architecture, Secure Database Views

---

## Featured Engineering Projects

### 1. Enterprise Railway Transit Management System
**Focus:** *Database Architecture, 3NF Normalization, & High-Dimensional Schema Design*

*   **Architecture & Design:** Engineered and validated a comprehensive 50-table relational database schema modeled to handle high-frequency transits, ticketing systems, passenger logistics, and asset maintenance tracking.
*   **Normalization:** Normalized all tables to 3NF to strictly maintain data integrity, eliminate update anomalies, and enforce exact relational symmetry.
*   **Relational Integrity:** Implemented complex relational hierarchies utilizing multi-table foreign keys, cascading deletions, and conditional triggers to manage pass validation and route schedules automatically.

```sql
-- Architectural Snippet: Relational View of Multi-Table Transit Metrics
CREATE VIEW City_View_Travel_MaleFemale_2016_2017 AS
SELECT TOP 50		
    cs.name AS city_name, 
    COUNT(DISTINCT t.travel_id) AS total_travels, 
    COUNT(DISTINCT CASE WHEN c.gender = 'M' THEN t.travel_id END) AS male_travels, 
    COUNT(DISTINCT CASE WHEN c.gender = 'F' THEN t.travel_id END) AS female_travels
FROM cities_states cs
JOIN customers c ON cs.city_state_id = c.city_state_id
JOIN tickets t ON c.customer_id = t.customer_id
JOIN travels tr ON t.travel_id = tr.travel_id
WHERE YEAR(tr.date) IN (2016, 2017)
GROUP BY cs.name
ORDER BY total_travels DESC;

-- Optimization Metric: Target Composite Index Architecture
CREATE INDEX idx_vessel_transit_date 
ON vessel_transits (vessel_id, transit_date);

-- Query Execution Time benchmark dropped from ~154ms to 0ms (CPU) post-indexing
SELECT * FROM vessel_transits 
WHERE vessel_id = 5000 AND transit_date > '2023-01-01';

-- Security Snippet: Secure Abstraction Layer via Isolated Views
CREATE ROLE intern_role;

CREATE VIEW intern_role_nosalary AS
SELECT emp_id, name, department
FROM Employees;

GRANT SELECT ON intern_role_nosalary TO intern_role;
