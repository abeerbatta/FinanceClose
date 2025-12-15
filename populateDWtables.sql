use FinanceCloseDemo

INSERT INTO dw.DimTime (FiscalYear, AccountingPeriod, FiscalQuarter)
SELECT DISTINCT
    CONVERT(
        INT,
        CONVERT(FLOAT, LTRIM(RTRIM(FISCAL_YEAR)))
    ) AS FiscalYear,
    CONVERT(
        INT,
        CONVERT(FLOAT, LTRIM(RTRIM(ACCOUNTING_PERIOD)))
    ) AS AccountingPeriod,
    CASE 
        WHEN CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(ACCOUNTING_PERIOD)))) IN (1,2,3)     THEN 1
        WHEN CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(ACCOUNTING_PERIOD)))) IN (4,5,6)     THEN 2
        WHEN CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(ACCOUNTING_PERIOD)))) IN (7,8,9)     THEN 3
        WHEN CONVERT(INT, CONVERT(FLOAT, LTRIM(RTRIM(ACCOUNTING_PERIOD)))) IN (10,11,12)  THEN 4
        ELSE NULL
    END AS FiscalQuarter
FROM stg.GeneralLedgerRaw;


-- Fund
INSERT INTO dw.DimFund (FundCode, FundDescr)
SELECT DISTINCT
    FUND_CODE,
    FUNDDESCR
FROM stg.GeneralLedgerRaw;

-- Account
INSERT INTO dw.DimAccount (Account, AccountDescr)
SELECT DISTINCT
    ACCOUNT,
    ACCTDESCR
FROM stg.GeneralLedgerRaw;

-- Dept (if DEPTID mostly null you can skip, but this is fine)
INSERT INTO dw.DimDept (DeptID, DeptDescr)
SELECT DISTINCT
    DEPTID,
    DEPTDESCR
FROM stg.GeneralLedgerRaw;
