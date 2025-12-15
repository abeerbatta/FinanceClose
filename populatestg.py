import pandas as pd
import pyodbc

# 1. Read CSV
df = pd.read_csv(r"\\Mac\Home\Downloads\ledger_fy24_qtr3.csv")

# 2. Ensure all non-amount columns are strings
for col in df.columns:
    if col != "POSTED_TOTAL_AMT":
        df[col] = df[col].astype(str)

# 3. Clean amount
df["POSTED_TOTAL_AMT"] = pd.to_numeric(df["POSTED_TOTAL_AMT"], errors="coerce")

# 4. Connect
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=ABEERBATTA4A7E\\SQLEXPRESS;"
    "DATABASE=FinanceCloseDemo;"
    "Trusted_Connection=yes;"
)
cursor = conn.cursor()

insert_sql = """
INSERT INTO stg.GeneralLedgerRaw (
    AGENCYNBR, AGENCYNAME, LEDGER, FISCAL_YEAR, ACCOUNTING_PERIOD,
    FUND_CODE, FUNDDESCR, CLASS_FLD, CLASSDESCR,
    DEPTID, DEPTDESCR, ACCOUNT, ACCTDESCR,
    OPERATING_UNIT, OPERUNITDESCR, PRODUCT, PRODUCTDESCR,
    PROGRAM_CODE, PGMDESCR, BUDGET_REF,
    CHARTFIELD1, CF1DESCR, CHARTFIELD2, CF2DESCR,
    PROJECT_ID, PROJDESCR, POSTED_TOTAL_AMT,
    ACTIVITY, ACTVDESCR, RESTYPE, RESDESCR,
    RCAT, RCATDESCR, RSUBCAT, RSUBCATDESCR, ROWID
)
VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
"""

for _, row in df.iterrows():
    cursor.execute(insert_sql, *[row[col] for col in df.columns])

conn.commit()
cursor.close()
conn.close()
