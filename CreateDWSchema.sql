CREATE SCHEMA dw;
GO

CREATE TABLE dw.DimTime (
    TimeKey          INT IDENTITY(1,1) PRIMARY KEY,
    FiscalYear       INT,
    AccountingPeriod INT,
    FiscalQuarter    INT,
    YearPeriodLabel  AS (CONCAT(FiscalYear, '-P', AccountingPeriod)) PERSISTED
);

CREATE TABLE dw.DimFund (
    FundKey   INT IDENTITY(1,1) PRIMARY KEY,
    FundCode  NVARCHAR(10),
    FundDescr NVARCHAR(255)
);

CREATE TABLE dw.DimAccount (
    AccountKey    INT IDENTITY(1,1) PRIMARY KEY,
    Account       NVARCHAR(10),
    AccountDescr  NVARCHAR(255),
    HighLevelType NVARCHAR(50) NULL
);

CREATE TABLE dw.DimDept (
    DeptKey   INT IDENTITY(1,1) PRIMARY KEY,
    DeptID    NVARCHAR(20),
    DeptDescr NVARCHAR(255)
);
