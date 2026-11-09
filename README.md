# Blood Donation and Inventory Management System

A relational database project developed with **Microsoft SQL Server (MSSQL)** for managing blood donors, donations, blood units and hospital inventories in Turkey.

📄 [EER Diagram (PDF)](docs/EER_Diagram.pdf)

## Tables

| Table              | Description                                  |
| ------------------ | -------------------------------------------- |
| **Cities**         | 81 provinces of Turkey and their regions     |
| **Hospitals**      | Hospitals and the city they are located in   |
| **Donors**         | Blood donors, identified by their TCKN       |
| **Donations**      | Donations made by donors at hospitals        |
| **BloodInventory** | Blood stock of each hospital per blood group |
| **BloodUnit**      | Blood components produced from each donation |
| **UnitUsage**      | Records of blood units used for patients     |

## Specializations

- **Donor** → Volunteer / Replacement (disjoint, total)
- **Hospital** → State / Private / University (disjoint, total)
- **BloodUnit** → Red_Cells / Plasma / Platelets (disjoint, total)

## Features

- **Natural primary key:** donors are identified by TCKN instead of a surrogate ID.
- **Domain rules:** every column is defined as `NULL` or `NOT NULL`, and `CHECK` constraints limit the allowed values (blood groups, statuses, types, dates).
- **Data integrity:**
  - A failed unit must be discarded.
  - Only tested units can be used.
  - A donation can produce only one unit of each component.
- **Realistic data:** 1,000 donors generated according to Turkish statistics (blood group, age, gender and regional distributions) and Kızılay donation rules.
- **Triggers:**
  - `trg_UpdateInventoryOnDonation` – increases the hospital stock when a donation is recorded
  - `trg_CheckExpirationDate` – marks expired units as _Expired_
  - `trg_CheckDonationRules` – checks donor age (18–65), the 90-day gap and the maximum of 4 donations per year
- **Views:** available blood units, donor donation history, hospital inventory status (critical stock warning)
- **Stored procedures:** registering a new donor and recording a new donation

## Files

| File                           | Description                        |
| ------------------------------ | ---------------------------------- |
| `sql/01_create_database.sql`   | Creates the database               |
| `sql/02_create_tables.sql`     | Creates the tables and constraints |
| `sql/03_insert_data.sql`       | Realistic data for 1,000 donors    |
| `sql/04_create_views.sql`      | Views                              |
| `sql/05_create_procedures.sql` | Stored procedures                  |
| `sql/06_create_triggers.sql`   | Triggers                           |
| `sql/07_queries.sql`           | Analytical queries                 |

## How to Run

Run the files in **SQL Server Management Studio (SSMS)** in order, from `01` to `07`.

> All personal data (names, TCKNs, phone numbers, e-mails) is fictional.
