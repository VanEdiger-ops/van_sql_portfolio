# database_engineering_portfolio
A collection of database projects demonstrating relational database design, SQL development, NoSQL concepts, data integrity, query optimization, and transaction management using Microsoft SQL Server and MongoDB.

## Skills Demonstrated

### SQL Server
- Relational Database Design
- Third Normal Form (3NF)
- Primary & Foreign Keys
- Check & Default Constraints
- Trigger Development
- Joins and Aggregations
- Query Optimization
- Indexing
- Transactions and Rollbacks
- T-SQL

### MongoDB (NoSQL)
- Database Creation
- Collection Creation
- Document Insertion
- Document Queries
- Document Updates
- Document Deletion
- Basic NoSQL Database Concepts

## Repository Contents

## SQL Server

### 1. `01_schema_and_constraints.sql`
**Focus:** Database Design & Constraints

Contains the database schema along with:
- Primary Keys
- Foreign Keys
- Check Constraints
- Default Constraints
- Referential Integrity Rules

### 2. `02_triggers.sql`
**Focus:** Triggers

Contains triggers that automatically enforce database rules.

Examples include:
- Date validation
- Text length validation
- Automatic rollback when invalid data is entered

### 3. `03_queries_and_analysis.sql`
**Focus:** Queries & Analysis

Contains queries that use joins, grouping, and aggregation to answer questions about the data.

Example:

```sql
SELECT
    tr.travel_id,
    COUNT(DISTINCT ti.ticket_id) AS ticket_demand,
    COUNT(DISTINCT pt.pass_id) AS pass_demand,
    COUNT(DISTINCT ti.ticket_id) + COUNT(DISTINCT pt.pass_id) AS total_demand
FROM travels AS tr
LEFT JOIN tickets AS ti
    ON ti.travel_id = tr.travel_id
LEFT JOIN passes_travels AS pt
    ON pt.travel_id = tr.travel_id
GROUP BY tr.travel_id
ORDER BY total_demand DESC;
```

This query compares ticket and pass demand for each travel record.

### 4. `04_optimized_indexes.sql`
**Focus:** Indexing & Performance

Demonstrates:
- Full Table Scans
- Single-Column Indexes
- Composite Indexes
- Query Performance Testing
Performance tests were run on large datasets to compare query speeds before and after indexing.

### 5. `05_transactions.sql`
**Focus:** Transactions
Demonstrates safe database operations using:
- `BEGIN TRANSACTION`
- `COMMIT`
- `ROLLBACK`
- `TRY...CATCH`
Examples include account transfers and rollback scenarios that help maintain data consistency when errors occur.

## MongoDB

### 1. `06_mongodb_queries.js`
**Focus:** Basic NoSQL Operations

Demonstrates introductory MongoDB concepts, including:
- Creating a database
- Creating collections
- Inserting documents
- Querying documents
- Updating documents
- Deleting documents
Examples demonstrate document-based storage and querying using MongoDB collections.

## Technologies Used
- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- MongoDB
  
## Key Learning Outcomes
- Designed normalized relational databases
- Enforced data integrity using constraints and triggers
- Wrote analytical queries using joins and aggregations
- Improved query performance with indexes
- Implemented transactions and rollback recovery
- Applied SQL Server best practices in database development
- Applied basic NoSQL concepts using MongoDB
