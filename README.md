# **Global Supply Chain Logistics & Risk Control Tower**

### **Project Overview**

This project provides an end-to-end analytical solution for monitoring and optimizing global supply chain operations. Utilizing a dataset of over **180,000 transactions** sourced from **Kaggle**, I developed a high-performance "Control Tower" dashboard that identifies systemic shipping bottlenecks, quantifies revenue at risk, and uncovers high-margin fraud patterns.

The project demonstrates a full-stack data pipeline: from raw data orchestration in **Python** to complex transactional modeling in **PostgreSQL**, culminating in executive-level storytelling via **Tableau Desktop**.

---

### **Business Problem Statement**

DataCo faced a critical **OTIF (On-Time In-Full) rate of just 45.17%**, leaving over **$20.1 million in revenue at risk** due to logistics failures. The primary challenge was a lack of visibility into:

* Specific city-to-city shipping bottlenecks.
* High-profit product categories vulnerable to fraud and cancellations.
* Warehouse capacity constraints during peak demand windows.

---

### **Tech Stack**

* **Python (Pandas, SQLAlchemy):** Data cleaning, feature engineering, and database ingestion.
* **PostgreSQL:** Advanced SQL querying, CTEs, and metric aggregation.
* **Tableau Desktop:** Interactive dashboarding and geospatial risk mapping.
* **Jupyter Notebook:** Initial EDA and data orchestration pipeline.

---

### **Key Features & Insights**

#### **1. Logistics Bottleneck Analysis**

Identified the **Top 20 Critical Routes** where actual shipping times consistently exceeded schedules by **2+ days**.

* **Key Finding:** Routes such as *Velsen to Caguas* were isolated as primary points of failure requiring immediate carrier audits.

#### **2. Financial Risk & Fraud Profiling**

Classified product categories into a "Risk-to-Reward" matrix to protect high-margin revenue.

* **Key Finding:** **Computers** and **Electronics** generate peak profit per unit but suffer from the highest rates of suspected fraud.

#### **3. Operational Load Heatmap**

Mapped order volume by hour and weekday to identify infrastructure stress.

* **Key Finding:** A consistent demand spike occurs between **10:00 AM and 4:00 PM**, correlating with delivery delays and indicating a need for shift optimization.

---

### **Mitigation Strategies Developed**

* **Carrier SLA Audits:** Prioritizing renegotiations for the 20 most-delayed shipping lanes.
* **High-Risk Verification:** Implementing enhanced authentication for high-margin categories like *Computers* to reduce cancellations.
* **Labor Realignment:** Adjusting warehouse staffing to match the identified 10 AM – 4 PM peak order window.

---

### **Project Structure**

* `project.ipynb`: Python notebook for data cleaning, EDA, and PostgreSQL migration.
* `dataco_supply_chain.sql`: Complex SQL queries used for pre-aggregating KPIs and answering business questions.
* `dataco_cleaned.csv`: The processed dataset exported for visualization.

---

### **How to Run**

1. Clone the repository.
2. Run `project.ipynb` to clean the raw data and ingest it into your local PostgreSQL instance.
3. Execute the queries in `dataco_supply_chain.sql` to generate analytical views.
4. Connect Tableau to your PostgreSQL instance or the cleaned CSV to view the interactive dashboard.
