
INSERT INTO dw.FactGL (TimeKey, FundKey, AccountKey, DeptKey, PostedTotalAmt)
SELECT
    t.TimeKey,
    f.FundKey,
    a.AccountKey,
    d.DeptKey,
    CONVERT(DECIMAL(18,2), CONVERT(FLOAT, s.POSTED_TOTAL_AMT))
FROM stg.GeneralLedgerRaw s
JOIN dw.DimTime t
    ON t.FiscalYear       = CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(s.FISCAL_YEAR))))
   AND t.AccountingPeriod = CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(s.ACCOUNTING_PERIOD))))
JOIN dw.DimFund f
    ON f.FundCode = s.FUND_CODE
JOIN dw.DimAccount a
    ON a.Account = s.ACCOUNT
LEFT JOIN dw.DimDept d
    ON d.DeptID = s.DEPTID;

