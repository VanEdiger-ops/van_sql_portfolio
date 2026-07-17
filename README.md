# Database Engineering Portfolio

A collection of database projects demonstrating relational database design, SQL development, NoSQL concepts, data integrity, query optimization, and transaction management using Microsoft SQL Server and MongoDB.

## Project Overview

This repository demonstrates database engineering concepts through the development of a transportation management database system using Microsoft SQL Server and MongoDB.

The SQL Server implementation focuses on relational database design, normalization, data integrity, performance optimization, and transaction management. The MongoDB implementation demonstrates NoSQL document modeling, CRUD operations, and flexible schema design.

The projects were developed to demonstrate practical database development workflows including schema creation, validation, querying, optimization, and maintaining reliable data operations.

---

# Skills Demonstrated

## SQL Server

- Relational Database Design
- Entity Relationship Modeling
- Third Normal Form (3NF)
- Primary & Foreign Keys
- Check & Default Constraints
- Referential Integrity
- Trigger Development
- Views
- Joins and Aggregations
- T-SQL
- Query Optimization
- Clustered and Non-Clustered Indexing
- Composite Indexes
- Transactions and Rollbacks
- ACID Properties

## MongoDB (NoSQL)

- Database Creation
- Collection Creation
- Document-Based Data Modeling
- CRUD Operations
- Document Insertion
- Document Queries
- Nested Document Queries
- Embedded Documents
- Arrays of Documents
- Document Updates
- MongoDB Query Operators
- Document Deletion
- Flexible Schema Design

---

# Repository Contents

## SQL Server

## 1. `01_schema_and_constraints.sql`

**Focus:** Database Design & Constraints

Contains the database schema along with:

- Primary Keys
- Foreign Keys
- Check Constraints
- Default Constraints
- Referential Integrity Rules
- Entity Relationships

The relational database was designed using normalization principles to achieve Third Normal Form (3NF), reducing redundancy and improving data integrity.

---

## 2. `02_triggers.sql`

**Focus:** Triggers

Contains triggers that automatically enforce database rules.

Examples include:

- Date validation
- Text length validation
- Data validation rules
- Automatic rollback when invalid data is entered

Triggers were used to enforce business rules and maintain database consistency.

---

## 3. `03_queries_and_analysis.sql`

**Focus:** Queries & Analysis

Contains SQL queries using joins, grouping, and aggregation to analyze data and answer business questions.

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

This query compares ticket and pass demand for each travel record using relational joins and aggregation.

---

## 4. `04_indexing_and_performance.sql`

**Focus:** Indexing & Performance Optimization

Demonstrates:

- Full Table Scans
- Clustered Indexes
- Non-Clustered Indexes
- Single-Column Indexes
- Composite Indexes
- Query Performance Testing

Performance testing was performed using simulated datasets to compare query execution times before and after implementing indexes.

---

## 5. `05_transactions.sql`

**Focus:** Transactions

Demonstrates safe database operations using:

- `BEGIN TRANSACTION`
- `COMMIT`
- `ROLLBACK`
- `TRY...CATCH`

Examples include multi-step operations, account transfers, and rollback scenarios designed to maintain data consistency when errors occur.

---

# MongoDB

## 6. `06_mongodb_queries.js`

**Focus:** NoSQL Document Operations

Demonstrates introductory MongoDB concepts, including:

- Creating databases
- Creating collections
- Document insertion
- Document querying
- Updating documents
- Updating arrays
- Deleting documents
- Embedded documents
- Arrays of documents
- Document-based storage

Examples demonstrate flexible schema design and querying using MongoDB collections.

---

# Database Concepts Applied

## Relational Database Concepts

- Entity Relationship Modeling
- Normalization
- Third Normal Form (3NF)
- Primary and Foreign Keys
- Constraints
- Referential Integrity
- SQL Query Development
- Data Validation
- Index Optimization
- Transaction Management
- ACID Properties

## NoSQL Concepts

- Document Storage
- Schema Flexibility
- Embedded Data
- Array Fields
- Nested Queries
- CRUD Operations

---

# Repository Structure

```
database_engineering_portfolio/

├── 01_schema_and_constraints.sql
├── 02_triggers.sql
├── 03_queries_and_analysis.sql
├── 04_indexing_and_performance.sql
├── 05_transactions.sql
├── 06_mongodb_queries.js
└── README.md
```

---

06_mongodb_queries.js
```

---

# Technologies Used

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- MongoDB
- MongoDB Shell (`mongosh`)
- JSON Document Format

---

# Key Learning Outcomes

- Designed normalized relational databases
- Modeled database relationships and dependencies
- Enforced data integrity using constraints and triggers
- Developed analytical queries using joins and aggregations
- Improved query performance through indexing
- Implemented transactions and rollback recovery
- Applied SQL Server database development practices
- Designed and queried NoSQL document-based databases using MongoDB
