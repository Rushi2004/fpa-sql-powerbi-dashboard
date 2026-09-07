USE fpa_finance_project;

SHOW TABLES;

DESCRIBE departments;      
INSERT INTO departments (department_name, department_manager, cost_centre)
VALUES
('Finance', 'Sarah Wilson', 'CC100'),
('Operations', 'James Brown', 'CC200'),
('Sales', 'Emma Taylor', 'CC300'),
('Marketing', 'Daniel Harris', 'CC400'),
('Technology', 'Olivia Clark', 'CC500');
SELECT *
FROM departments;
CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    budget_month DATE NOT NULL,
    budget_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
DESCRIBE budgets;
INSERT INTO budgets (department_id, budget_month, budget_amount)
VALUES
(1, '2026-01-01', 120000.00),
(2, '2026-01-01', 250000.00),
(3, '2026-01-01', 180000.00),
(4, '2026-01-01', 95000.00),
(5, '2026-01-01', 210000.00);
SELECT *
FROM budgets
ORDER BY budget_id;DELETE FROM budgets
WHERE budget_id BETWEEN 6 AND 10;
USE fpa_finance_project;

DELETE FROM budgets
WHERE budget_id BETWEEN 6 AND 10;

SELECT *
FROM budgets
ORDER BY budget_id;
ALTER TABLE budgets
ADD CONSTRAINT uq_department_month
UNIQUE (department_id, budget_month);
ALTER TABLE budgets
ADD CONSTRAINT uq_department_month
UNIQUE (department_id, budget_month);
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    department_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(150),
    amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
INSERT INTO budgets (department_id, budget_month, budget_amount)
VALUES
(1, '2026-02-01', 125000.00),
(2, '2026-02-01', 255000.00),
(3, '2026-02-01', 185000.00),
(4, '2026-02-01', 100000.00),
(5, '2026-02-01', 215000.00),
(1, '2026-03-01', 130000.00),
(2, '2026-03-01', 260000.00),
(3, '2026-03-01', 190000.00),
(4, '2026-03-01', 105000.00),
(5, '2026-03-01', 220000.00);
SELECT *
FROM budgets
ORDER BY budget_month, department_id;
INSERT INTO transactions
(transaction_date, department_id, transaction_type, category, description, amount)
VALUES
('2026-01-05', 3, 'Revenue', 'Client Sales', 'January client revenue', 540000.00),
('2026-01-07', 1, 'Expense', 'Payroll', 'Finance team salaries', 82000.00),
('2026-01-09', 1, 'Expense', 'Professional Fees', 'Audit and advisory costs', 18000.00),
('2026-01-11', 2, 'Expense', 'Logistics', 'Distribution and transport', 172000.00),
('2026-01-13', 2, 'Expense', 'Facilities', 'Warehouse and utilities', 64000.00),
('2026-01-15', 3, 'Expense', 'Sales Commission', 'Sales team commission', 97000.00),
('2026-01-17', 3, 'Expense', 'Travel', 'Client meetings and travel', 52000.00),
('2026-01-19', 4, 'Expense', 'Advertising', 'Digital marketing campaign', 68000.00),
('2026-01-21', 4, 'Expense', 'Events', 'Customer acquisition event', 24000.00),
('2026-01-23', 5, 'Expense', 'Technology', 'Cloud and software costs', 196000.00);
INSERT INTO transactions
(transaction_date, department_id, transaction_type, category, description, amount)
VALUES
('2026-02-04', 3, 'Revenue', 'Client Sales', 'February client revenue', 575000.00),
('2026-02-06', 1, 'Expense', 'Payroll', 'Finance team salaries', 84000.00),
('2026-02-09', 1, 'Expense', 'Professional Fees', 'Tax and consulting costs', 22000.00),
('2026-02-11', 2, 'Expense', 'Logistics', 'Distribution and transport', 184000.00),
('2026-02-13', 2, 'Expense', 'Facilities', 'Warehouse and utilities', 78000.00),
('2026-02-16', 3, 'Expense', 'Sales Commission', 'Sales team commission', 101000.00),
('2026-02-18', 3, 'Expense', 'Travel', 'Client meetings and travel', 61000.00),
('2026-02-20', 4, 'Expense', 'Advertising', 'Digital marketing campaign', 79000.00),
('2026-02-22', 4, 'Expense', 'Events', 'Customer acquisition event', 27000.00),
('2026-02-25', 5, 'Expense', 'Technology', 'Cloud and software costs', 208000.00);
SELECT COUNT(*) AS total_transactions
FROM transactions;
INSERT INTO transactions
(transaction_date, department_id, transaction_type, category, description, amount)
VALUES
('2026-03-04', 3, 'Revenue', 'Client Sales', 'March client revenue', 620000.00),
('2026-03-06', 1, 'Expense', 'Payroll', 'Finance team salaries', 90000.00),
('2026-03-09', 1, 'Expense', 'Professional Fees', 'Audit and consulting costs', 28000.00),
('2026-03-11', 2, 'Expense', 'Logistics', 'Distribution and transport', 195000.00),
('2026-03-13', 2, 'Expense', 'Facilities', 'Warehouse and utilities', 78000.00),
('2026-03-16', 3, 'Expense', 'Sales Commission', 'Sales team commission', 115000.00),
('2026-03-18', 3, 'Expense', 'Travel', 'Client meetings and travel', 82000.00),
('2026-03-20', 4, 'Expense', 'Advertising', 'Digital marketing campaign', 76000.00),
('2026-03-22', 4, 'Expense', 'Events', 'Customer acquisition event', 22000.00),
('2026-03-25', 5, 'Expense', 'Technology', 'Cloud and software costs', 232000.00);
WITH actuals AS (
    SELECT department_id,
           EXTRACT(YEAR_MONTH FROM transaction_date) AS month_key,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, EXTRACT(YEAR_MONTH FROM transaction_date)
)
SELECT d.department_name, b.budget_month, b.budget_amount,
       COALESCE(a.actual_spend, 0) AS actual_spend,
       b.budget_amount - COALESCE(a.actual_spend, 0) AS variance
FROM budgets b
JOIN departments d ON b.department_id = d.department_id
LEFT JOIN actuals a ON b.department_id = a.department_id
AND EXTRACT(YEAR_MONTH FROM b.budget_month) = a.month_key
ORDER BY b.budget_month, d.department_name;
WITH actuals AS (
    SELECT department_id,
           EXTRACT(YEAR_MONTH FROM transaction_date) AS month_key,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, EXTRACT(YEAR_MONTH FROM transaction_date)
)
SELECT d.department_name,
       b.budget_month,
       b.budget_amount,
       COALESCE(a.actual_spend, 0) AS actual_spend,
       b.budget_amount - COALESCE(a.actual_spend, 0) AS variance,
       ROUND(((COALESCE(a.actual_spend, 0) - b.budget_amount)
              / NULLIF(b.budget_amount, 0)) * 100, 2) AS variance_pct,
       CASE
           WHEN COALESCE(a.actual_spend, 0) > b.budget_amount THEN 'Over Budget'
           WHEN COALESCE(a.actual_spend, 0) < b.budget_amount THEN 'Under Budget'
           ELSE 'On Budget'
       END AS budget_status
FROM budgets b
JOIN departments d ON b.department_id = d.department_id
LEFT JOIN actuals a
    ON b.department_id = a.department_id
    AND EXTRACT(YEAR_MONTH FROM b.budget_month) = a.month_key
ORDER BY b.budget_month, variance_pct DESC;
WITH monthly_actuals AS (
    SELECT department_id,
           EXTRACT(YEAR_MONTH FROM transaction_date) AS month_key,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, EXTRACT(YEAR_MONTH FROM transaction_date)
)
SELECT d.department_name, b.budget_month, b.budget_amount,
       a.actual_spend,
       ROUND((a.actual_spend - b.budget_amount) / b.budget_amount * 100, 2) AS overspend_pct,
       RANK() OVER (
           PARTITION BY b.budget_month
           ORDER BY (a.actual_spend - b.budget_amount) / b.budget_amount DESC
       ) AS spend_rank
FROM budgets b
JOIN departments d ON b.department_id = d.department_id
JOIN monthly_actuals a ON b.department_id = a.department_id
AND EXTRACT(YEAR_MONTH FROM b.budget_month) = a.month_key
ORDER BY b.budget_month, spend_rank;
WITH monthly_spend AS (
    SELECT department_id,
           DATE_FORMAT(transaction_date, '%Y-%m-01') AS spend_month,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
)
SELECT d.department_name, m.spend_month, m.actual_spend,
       LAG(m.actual_spend) OVER (
           PARTITION BY m.department_id
           ORDER BY m.spend_month
       ) AS previous_month_spend
FROM monthly_spend m
JOIN departments d ON m.department_id = d.department_id
ORDER BY d.department_name, m.spend_month;
WITH monthly_spend AS (
    SELECT department_id,
           DATE_FORMAT(transaction_date, '%Y-%m-01') AS spend_month,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
),
spend_change AS (
    SELECT *,
           LAG(actual_spend) OVER (
               PARTITION BY department_id ORDER BY spend_month
           ) AS previous_month_spend
    FROM monthly_spend
)
SELECT d.department_name, s.spend_month, s.actual_spend,
       s.previous_month_spend,
       ROUND((s.actual_spend - s.previous_month_spend)
             / NULLIF(s.previous_month_spend, 0) * 100, 2) AS mom_change_pct
FROM spend_change s
JOIN departments d ON s.department_id = d.department_id
ORDER BY d.department_name, s.spend_month;
WITH monthly_spend AS (
    SELECT department_id,
           DATE_FORMAT(transaction_date, '%Y-%m-01') AS spend_month,
           SUM(amount) AS actual_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY department_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
)
SELECT d.department_name,
       m.spend_month,
       m.actual_spend,
       SUM(m.actual_spend) OVER (
           PARTITION BY m.department_id
           ORDER BY m.spend_month
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_spend
FROM monthly_spend m
JOIN departments d
    ON m.department_id = d.department_id
ORDER BY d.department_name, m.spend_month;
WITH category_spend AS (
    SELECT category,
           SUM(amount) AS total_spend
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY category
)
SELECT category,
       total_spend,
       ROUND(
           total_spend / SUM(total_spend) OVER () * 100,
           2
       ) AS spend_contribution_pct
FROM category_spend
ORDER BY total_spend DESC;
WITH monthly_financials AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m-01') AS financial_month,
           SUM(CASE WHEN transaction_type = 'Revenue' THEN amount ELSE 0 END) AS total_revenue,
           SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expenses
    FROM transactions
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m-01')
)
SELECT financial_month,
       total_revenue,
       total_expenses,
       total_revenue - total_expenses AS operating_profit,
       ROUND((total_revenue - total_expenses) /
             NULLIF(total_revenue, 0) * 100, 2) AS profit_margin_pct
FROM monthly_financials
ORDER BY financial_month;
WITH monthly_financials AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m-01') AS financial_month,
           SUM(CASE WHEN transaction_type = 'Revenue' THEN amount ELSE 0 END) AS revenue,
           SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS expenses
    FROM transactions
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m-01')
),
performance AS (
    SELECT financial_month,
           revenue,
           revenue - expenses AS operating_profit,
           LAG(revenue) OVER (ORDER BY financial_month) AS previous_revenue
    FROM monthly_financials
)
SELECT financial_month,
       revenue,
       operating_profit,
       ROUND((revenue - previous_revenue) /
             NULLIF(previous_revenue, 0) * 100, 2) AS revenue_growth_pct
FROM performance
ORDER BY financial_month;
CREATE OR REPLACE VIEW vw_monthly_kpis AS
SELECT t.financial_month,
       t.total_revenue,
       t.total_expenses,
       t.total_revenue - t.total_expenses AS operating_profit,
       ROUND((t.total_revenue - t.total_expenses)
             / NULLIF(t.total_revenue, 0) * 100, 2) AS profit_margin_pct,
       b.total_budget,
       b.total_budget - t.total_expenses AS budget_variance
FROM (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m-01') AS financial_month,
           SUM(CASE WHEN transaction_type = 'Revenue' THEN amount ELSE 0 END) AS total_revenue,
           SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expenses
    FROM transactions
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m-01')
) t
LEFT JOIN (
    SELECT DATE_FORMAT(budget_month, '%Y-%m-01') AS financial_month,
           SUM(budget_amount) AS total_budget
    FROM budgets
    GROUP BY DATE_FORMAT(budget_month, '%Y-%m-01')
) b ON t.financial_month = b.financial_month;
SELECT *
FROM vw_monthly_kpis
ORDER BY financial_month;
CREATE OR REPLACE VIEW vw_department_performance AS
SELECT d.department_name,
       b.budget_month,
       b.budget_amount,
       COALESCE(SUM(t.amount), 0) AS actual_spend,
       b.budget_amount - COALESCE(SUM(t.amount), 0) AS variance,
       ROUND((COALESCE(SUM(t.amount), 0) - b.budget_amount)
             / NULLIF(b.budget_amount, 0) * 100, 2) AS variance_pct,
       CASE
           WHEN COALESCE(SUM(t.amount), 0) > b.budget_amount THEN 'Over Budget'
           WHEN COALESCE(SUM(t.amount), 0) < b.budget_amount THEN 'Under Budget'
           ELSE 'On Budget'
       END AS budget_status
FROM budgets b
JOIN departments d ON b.department_id = d.department_id
LEFT JOIN transactions t
    ON b.department_id = t.department_id
    AND t.transaction_type = 'Expense'
    AND YEAR(t.transaction_date) = YEAR(b.budget_month)
    AND MONTH(t.transaction_date) = MONTH(b.budget_month)
GROUP BY d.department_name, b.budget_month, b.budget_amount;
SELECT *
FROM vw_department_performance
ORDER BY budget_month, department_name;
CREATE OR REPLACE VIEW vw_department_performance AS
SELECT d.department_name,
       b.budget_month,
       b.budget_amount,
       COALESCE(SUM(t.amount), 0) AS actual_spend,
       b.budget_amount - COALESCE(SUM(t.amount), 0) AS variance,
       ROUND((COALESCE(SUM(t.amount), 0) - b.budget_amount)
             / NULLIF(b.budget_amount, 0) * 100, 2) AS variance_pct,
       CASE
           WHEN COALESCE(SUM(t.amount), 0) > b.budget_amount THEN 'Over Budget'
           WHEN COALESCE(SUM(t.amount), 0) < b.budget_amount THEN 'Under Budget'
           ELSE 'On Budget'
       END AS budget_status
FROM budgets b
JOIN departments d ON b.department_id = d.department_id
LEFT JOIN transactions t
       ON b.department_id = t.department_id
      AND t.transaction_type = 'Expense'
      AND t.transaction_date >= b.budget_month
      AND t.transaction_date < DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
GROUP BY d.department_name, b.budget_month, b.budget_amount;
SELECT *
FROM vw_department_performance
ORDER BY budget_month, department_name;
CREATE INDEX idx_transactions_dept_type_date
ON transactions (department_id, transaction_type, transaction_date);
SELECT 'Invalid transaction records' AS quality_check,
       COUNT(*) AS issue_count
FROM transactions
WHERE transaction_date IS NULL
   OR department_id IS NULL
   OR category IS NULL
   OR amount <= 0

UNION ALL

SELECT 'Invalid transaction types',
       COUNT(*)
FROM transactions
WHERE transaction_type NOT IN ('Revenue', 'Expense')

UNION ALL

SELECT 'Invalid budget records',
       COUNT(*)
FROM budgets
WHERE department_id IS NULL
   OR budget_month IS NULL
   OR budget_amount <= 0

UNION ALL

SELECT 'Duplicate monthly budgets',
       COUNT(*)
FROM (
    SELECT department_id, budget_month
    FROM budgets
    GROUP BY department_id, budget_month
    HAVING COUNT(*) > 1
) duplicate_check;
SELECT 'Invalid transaction records' AS quality_check,
       COUNT(*) AS issue_count
FROM transactions
WHERE transaction_date IS NULL
   OR department_id IS NULL
   OR category IS NULL
   OR amount <= 0

UNION ALL

SELECT 'Invalid transaction types',
       COUNT(*)
FROM transactions
WHERE transaction_type NOT IN ('Revenue', 'Expense')

UNION ALL

SELECT 'Invalid budget records',
       COUNT(*)
FROM budgets
WHERE department_id IS NULL
   OR budget_month IS NULL
   OR budget_amount <= 0

UNION ALL

SELECT 'Duplicate monthly budgets',
       COUNT(*)
FROM (
    SELECT department_id, budget_month
    FROM budgets
    GROUP BY department_id, budget_month
    HAVING COUNT(*) > 1
) duplicate_check;
SELECT 'Invalid transaction records' AS quality_check,
       COUNT(*) AS issue_count
FROM transactions
WHERE transaction_date IS NULL
   OR department_id IS NULL
   OR category IS NULL
   OR amount <= 0;
   CREATE USER 'powerbi_user'@'192.168.64.%'
IDENTIFIED BY 'ChooseYourPassword123!';

GRANT SELECT ON fpa_finance_project.*
TO 'powerbi_user'@'192.168.64.%';

FLUSH PRIVILEGES;
ALTER USER 'powerbi_user'@'192.168.64.%'
IDENTIFIED BY 'Qwertyuiop@0987654321';
DROP USER IF EXISTS 'powerbi_user'@'192.168.64.%';
DROP USER IF EXISTS 'powerbi_user'@'192.168.64.2';

CREATE USER 'powerbi_user'@'192.168.64.2'
IDENTIFIED BY 'Qwertyuiop@0987654321';

GRANT SELECT ON fpa_finance_project.*
TO 'powerbi_user'@'192.168.64.2';

SHOW GRANTS FOR 'powerbi_user'@'192.168.64.2';

SELECT VERSION();

SELECT user, host, plugin, account_locked
FROM mysql.user
WHERE user = 'powerbi_user';

SHOW CREATE USER 'powerbi_user'@'192.168.64.2';
SELECT VERSION();
SELECT CONCAT(
    user, ' | ',
    host, ' | ',
    plugin, ' | ',
    account_locked
) AS account_details
FROM mysql.user
WHERE user = 'powerbi_user';
   CREATE OR REPLACE VIEW vw_transaction_detail AS
SELECT
    t.transaction_id,
    t.transaction_date,
    d.department_name,
    t.transaction_type,
    t.category,
    t.description,
    t.amount
FROM transactions t
JOIN departments 
    ON t.department_id = d.department_id;
    USE fpa_finance_project;
    CREATE OR REPLACE VIEW vw_transaction_detail AS
SELECT
    t.transaction_id,
    t.transaction_date,
    d.department_name,
    t.transaction_type,
    t.category,
    t.description,
    t.amount
FROM transactions t
JOIN departments d
    ON t.department_id = d.department_id;
    SELECT *
FROM vw_transaction_detail
ORDER BY transaction_date;
SELECT *
FROM vw_monthly_kpis
ORDER BY financial_month;
SELECT *
FROM vw_department_performance
ORDER BY budget_month, department_name;