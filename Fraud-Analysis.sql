-- 1. Total transactions
SELECT COUNT(*) AS total_transactions
FROM fraud_transactions;

-- 2. Total fraud cases
SELECT COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE fraudFlag = 1;

-- 3. Overall fraud rate
SELECT
    100.0 * SUM(CASE WHEN fraudFlag = 1 THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) AS fraud_rate_percent
FROM fraud_transactions;

-- 4. Amount at risk
SELECT
    SUM(CASE WHEN fraudFlag = 1 THEN amount ELSE 0 END) AS amount_at_risk
FROM fraud_transactions;

-- 5. Fraud cases by state
SELECT
    state,
    COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE fraudFlag = 1
GROUP BY state
ORDER BY fraud_cases DESC;

-- 6. Fraud cases by merchant category
SELECT
    merchantCategory,
    COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE fraudFlag = 1
GROUP BY merchantCategory
ORDER BY fraud_cases DESC;

-- 7. Fraud cases by device type
SELECT
    deviceType,
    COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE fraudFlag = 1
GROUP BY deviceType
ORDER BY fraud_cases DESC;

-- 8. Fraud cases by payment method
SELECT
    paymentMethod,
    COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE fraudFlag = 1
GROUP BY paymentMethod
ORDER BY fraud_cases DESC;

-- 9. Average risk score by fraud status
SELECT
    fraudFlag,
    AVG(riskScore) AS average_risk_score
FROM fraud_transactions
GROUP BY fraudFlag;

-- 10. High-risk transactions
SELECT *
FROM fraud_transactions
WHERE riskScore >= 80
ORDER BY riskScore DESC;

-- 11. Customer-level fraud analysis
SELECT
    customerId,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraudFlag = 1 THEN 1 ELSE 0 END) AS fraud_cases,
    SUM(CASE WHEN fraudFlag = 1 THEN amount ELSE 0 END) AS amount_at_risk,
    AVG(riskScore) AS average_risk_score
FROM fraud_transactions
GROUP BY customerId
ORDER BY amount_at_risk DESC;

-- 12. Top 10 customers by amount at risk
SELECT TOP 10
    customerId,
    SUM(CASE WHEN fraudFlag = 1 THEN amount ELSE 0 END) AS amount_at_risk
FROM fraud_transactions
GROUP BY customerId
ORDER BY amount_at_risk DESC;

-- 13. Merchant-level fraud rate
SELECT
    merchantCategory,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraudFlag = 1 THEN 1 ELSE 0 END) AS fraud_cases,
    100.0 * SUM(CASE WHEN fraudFlag = 1 THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) AS fraud_rate_percent
FROM fraud_transactions
GROUP BY merchantCategory
ORDER BY fraud_rate_percent DESC;
