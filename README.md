# DB Design for VOEBB

This database management system designed to partially simulate the functionality of
the [Verbund der Öffentlichen Bibliotheken Berlins (VÖBB)](https://www.voebb.de/aDISWeb/app?service=direct/0/Home/$DirectLink&sp=SPROD00).
It focuses exclusively on PostgreSQL, featuring a normalized schema, advanced SQL queries, and functionality to
handle library collections, reservations, borrowing processes, and detailed statistical reporting.

### Table of Contents

- [Features](#Features)
- [Database Schema](#database-schema)
- [Views and Utilities](#views-and-utilities)
- [Setup Instructions](#setup-instructions)
- [ SQL Queries](#sql-queries)

### Features

#### Database Design

- **Normalized schema** with relationships, constraints, and foreign keys
- Advanced use of PostgreSQL features: Partial indexes, GIN indexes, extensions [
  pg_trgm](https://www.alibabacloud.com/help/en/analyticdb/analyticdb-for-postgresql/user-guide/pg-trgm), [pg_cron](https://tembo.io/docs/getting-started/postgres_guides/extensions/pg_cron),
  views,
  and aggregate functions.

#### Core Functionalities

- Borrowing and returning:
    - Borrow items with automatic borrow_due_date calculation based on media_format.
    - Return items and update availability status.
    - Show borrowed history for each client.
- Reservations:
    - Reserve items for up to 3 days.
    - Cancel reservations manually or automatically when expired (via a scheduled cron job [extension
      ```pg_cron```](https://www.databasetour.net/documentation/managing-cron-jobs-in-postgresql-db.htm)).
- Statistics:
    - Detailed insights into library inventory, media format distribution, and item availability.
- Search:
    - Flexible and advanced search functionality, including full-text search across multiple tables.

#### Database Schema

Refer to the full schema in [ERD - dbdiagram.io](https://dbdiagram.io/d/VOEBB-67878fea6b7fa355c3f37e85).

The schema includes **23 tables** to manage library operations efficiently. Key tables:

- ```product```, ```media_format```, ```book```, ```video``` for cataloging items.
- ```product_item```, ```item_location```, ```item_status``` to manage item availability and location.
- ```borrow```, ```reservation``` to track client interactions.
- ```creator```, ```language```, ```country``` with their relations to track metadata.
  It enforces data consistency through foreign keys, constraints, and triggers.

### Views and Utilities

#### Views

1. ```full_item_info``` - provides detailed information about item location, statuses, and associated libraries,
   including their addresses.
2. ```main_page_info``` - aggregates product data to determine lists of libraries where an item is
   available.

#### Utility Function

1. ```validate_item_status()``` - verifies that an item is not already reserved or borrowed.
2. ```calculate_borrow_due_date()``` - automatically calculates borrowing due dates based on media format.
3. ```search_across_multiple_tables()``` - full-text search function across titles, creators, and notes.

#### Indexes

1. GIN Index
    - ```idx_gin_product_search``` - optimizes queries on full-search and similarity on product title, notes.
    - ```idx_gin_creator_search``` - optimizes queries on full-search on creator names.
2. PARTIAL Index
    - ```idx_product_link_to_emedia_not_null``` - optimizes queries on digital items (product_link_to_emedia).

### Project Developer Team

- [Alex Bruch](https://github.com/bruch-alex)
- [Natalie Lazarev](https://github.com/nat-laz)

### Setup Instructions

1. Create database:

    ```sql
    CREATE DATABASE <your-db-name>;
    ```

2. Run schema script:

    ```sql
    psql -d <your-database-name> -f initialization/initialization.sql
    ```

3. Populate tables with sample data:

    ```sql
    psql -d <your-database-name> -f initialization/initial_service_data.sql
    ```
    
    ```sql
    psql -d <your-database-name> -f initialization/setup_jobs.sql
    ```
    
    ```sql
    psql -d <your-database-name> -f initialization/cancel_expired_reservation_script.sql
    ```
    
    ```sql
    psql -d <your-database-name> -f initialization/cancel_expired_reservation_script.sql
    ```
    
    ```sql
    psql -d <your-database-name> -f initialization/cancel_expired_reservation_script.sql
    ```
    
    ```sql
    psql -d <your-database-name> -f initialization/generate_random_data.sql
    ```



### Play with queries 

