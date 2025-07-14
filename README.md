# sql-advance

[![License: Custom MIT](https://img.shields.io/badge/License-Custom%20MIT-yellow.svg)](LICENSE)

A curated collection of advanced SQL topics, hands-on exercises, and sample projects to help you master SQL for analytics, reporting, and performance tuning.

## Table of Contents
- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Setup](#setup)
- [SQL Views & Analysis](#sql-views--analysis)
- [Advanced Topics](#advanced-topics)
- [Final Project](#final-project)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview
This repository is divided into two parts:
1. **advance-sql-concepts**  
   Covers all advanced SQL functionalities with explanations, sample data, and exercises.  
2. **final-project**  
   End-to-end sample projects showcasing complex SQL queries and solutions.

## Repository Structure
```

.
├── advance-sql-concepts/        # Theoretical topics & query exercises
│   ├── 01-\*.sql                 # Database & data setup scripts
│   └── *.sql                    # Advanced query exercises
├── final-project/               # Capstone project(s) with solutions
│   ├── 01-*.sql                 # Project schema & data setup
│   └── \*.sql                    # Project solution queries
├── resources/
│   ├── databricks-archive/      # .dbc files for Databricks import
│   └── html-formatted-files/    # HTML-formatted views with sample output
├── LICENSE                      # Custom MIT-style license with extra clauses
├── .gitignore
└── README.md

```

## Setup
Choose **one** of the following approaches:

1. **Standard SQL client**  
   - In each of the two folders (`advance-sql-concepts` and `final-project`), run the `01-*.sql` scripts to create databases and load data.  
   - Then execute the remaining `.sql` files to work through the advanced queries.

2. **Databricks SQL (optional)**  
   - Import the `.dbc` archives from `resources/databricks-archive/` directly into your Databricks workspace.  
   - They include both setup and query notebooks, ready to run.

## SQL Views & Analysis
For a quick, visual view of tables and query outputs, open the HTML files in `resources/html-formatted-files/`. These include rendered schemas and sample results to guide your analysis.

## Advanced Topics
- **Common Table Expressions (CTEs)** & Recursive Queries  
- **Window Functions** (ROW_NUMBER, RANK, LEAD, LAG, NTILE)  
- **Analytical & Aggregate Functions**  
- **Advanced JOINs** & Set Operations  
- **PIVOT/UNPIVOT** and **JSON Handling**  
- **Performance Tuning** & Execution Plan Analysis  
- **Indexing Strategies**  
- **Temporal & Time-Series Queries**  

## Final Project
An end-to-end SQL capstone: design schemas, load real-world datasets, and craft complex queries to solve business scenarios.  
See `final-project/README.md` for detailed instructions and deliverables.

## Resources
- **Cheat-sheets & references** in `resources/`  
- **Databricks notebooks** in `resources/databricks-archive/`  
- **HTML-formatted examples** in `resources/html-formatted-files/`

## Contributing
Contributions welcome!  
1. Fork the repo  
2. Create a branch (`git checkout -b feature/your-topic`)  
3. Add or improve content  
4. Submit a Pull Request

## License
This project is licensed under a custom MIT-style license. See the [LICENSE](LICENSE) file for full terms.

## Contact
Maintained by [ForeverKrish](https://github.com/ForeverKrish).  
Feel free to open issues or reach out with suggestions!