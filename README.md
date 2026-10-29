# Blood Donation and Inventory Management System

A relational database for managing blood donations, hospital blood stocks and donor records.
The whole project is written in SQL on **Microsoft SQL Server (MSSQL)**.

📄 [EER Diagram (PDF)](docs/EER_Diagram.pdf)

## Tables

| Table          | Description                                |
| -------------- | ------------------------------------------ |
| Cities         | Cities and their regions                   |
| Hospitals      | Hospitals and their types                  |
| Donors         | Blood donors                               |
| Donations      | Donations made by donors at hospitals      |
| BloodInventory | Stock of each blood group in each hospital |
| BloodUnit      | Blood components produced from donations   |
| UnitUsage      | Units transfused to patients               |

**Specializations (disjoint, total):**

- Hospitals → State, Private, University
- Donors → Volunteer, Replacement
- BloodUnit → Red_Cells, Plasma, Platelets

All foreign keys are `NOT NULL`, and `CHECK` constraints define the allowed values
(blood groups, types, minimum donor age of 18, positive unit counts).

## Features

- **Views:** available blood units, donor donation history, hospital stock status (CRITICAL / SUFFICIENT)
- **Stored procedures:** register a new donor, record a new donation
- **Triggers:** update the stock of the donor's blood group after a donation, mark expired units
- **Queries:** critical stock detection, donor history report, blood group distribution, location-based inventory

## How to Run

Run the files in the `sql` folder in order in SQL Server Management Studio (SSMS):

| File                     | Content                      |
| ------------------------ | ---------------------------- |
| 01_create_database.sql   | Creates the database         |
| 02_create_tables.sql     | Tables, keys and constraints |
| 03_insert_data.sql       | Sample data                  |
| 04_create_views.sql      | Views                        |
| 05_create_procedures.sql | Stored procedures            |
| 06_create_triggers.sql   | Triggers                     |
| 07_queries.sql           | Analytical queries           |

## Author

Eyüphan Gündüz (230303019) – Computer Engineering, İstanbul Arel University
