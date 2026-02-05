# Accounts Receivable & Sales Performance Analytics

## 📊 Project Overview
This project provides a full-stack solution for monitoring corporate financial health, specifically focusing on the relationship between Sales Performance and Cash Collection Efficiency. By integrating SQL Server, Python, and Power BI, the project transforms raw transaction data into actionable insights regarding liquidity and credit risk.

## 🛠️ Tech Stack
- Database: SQL Server (T-SQL) for data warehousing and view orchestration.
- ETL & Data Science: Python (Pandas, NumPy, SQLAlchemy) for realistic payment delay simulation and data transformation.
- Visualization: Power BI (DAX) for interactive dashboarding and KPI tracking.

## 🏗️ Data Pipeline & Architecture
1. SQL Server Layer (The Foundation)
Data is sourced from a refined Star Schema within the AdventureWorks database.
- Production View: Created v_FinancialAnalysis using LEFT JOINs to ensure 100% financial integrity, ensuring no sales records are lost even if dimension attributes are missing.
- Data Cleaning: Implemented ISNULL logic and string concatenation to prepare "clean" fields for the reporting layer.

2. Python Layer (The Simulation & ETL)
Since standard databases often lack granular payment dates, I developed a Python script to simulate realistic business behavior.
- Statistical Simulation: Used a Gamma Distribution to generate realistic payment delays, creating a "long-tail" effect typical in B2B finance.
- Feature Engineering: Automated the calculation of Aging Buckets (On Time, 1-30 Days, etc.) and DaysToPay.
- Error Handling: The script includes a robust try-except structure and logging to handle SQL connection issues or file permission errors.

3. Power BI Layer (The Insights)
The final dashboard provides a multi-dimensional view of company performance.
- DSO (Days Sales Outstanding): Implemented a 3-Month Rolling Average line to smooth out monthly volatility and reveal the true collection trend.
- CEI (Collection Effectiveness Index): A critical KPI measuring the quality of the collection process.
- Dynamic UX: Features synchronized slicers and Conditional Formatting on the Gauge chart to immediately signal if YTD sales are lagging behind the previous year.

## 📈 Key Insights Captured
- Aging Breakdown: Identifies that while 80% of debt is "1-30 Days Late," the CEI remains high, suggesting a stable but slightly delayed cash inflow.
- Regional Trends: Users can filter by Country (e.g., United States, Australia) to see how collection efficiency varies by market.
- Target Achievement: The Gauge visual provides an "at-a-glance" status of current YTD sales vs. targets, using semantic colors (Red/Green) for instant interpretation.

🚀 How to Run
1. SQL: Execute the deployment script in SSMS to create the v_FinancialAnalysis view.
2. Python: Run the financial_analysis.ipynb (or .py) script. Ensure ipykernel and pyodbc are installed in your environment.
3. Power BI: Open the .pbix file and click Refresh to pull the latest data from the generated finance_data_ready.csv.

graph LR
A[(SQL Server)] -- "View v_FinancialAnalysis" --> B[Python ETL]
B -- "Gamma Simulation" --> C(finance_data_ready.csv)
C --> D{Power BI Dashboard}
