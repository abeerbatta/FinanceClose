<h1>FinanceClose</h1>
<h2>A Mini Financial Close &amp; Reporting Pipeline</h2>

<h2>Overview</h2>
<p>
FinanceClose simulates a mini financial close and “last-mile” reporting pipeline using a real General Ledger (GL) extract.
It demonstrates how raw GL data can be centralized, modeled into an OLAP-friendly star schema, and surfaced through an
interactive P&amp;L report in Power BI—mirroring how enterprise finance platforms such as Longview Close and Workiva (Wdata)
support financial close and reporting.
</p>

<p>
This project is designed to showcase financial systems thinking, dimensional modeling, and reporting workflows commonly
used in corporate finance transformation teams.
</p>

<h2>Project Goals</h2>
<ul>
  <li>Simulate ingestion of raw GL data from an upstream source</li>
  <li>Centralize and cleanse data in SQL Server</li>
  <li>Model data into a dimensional star schema</li>
  <li>Expose an interactive Profit &amp; Loss (P&amp;L) report</li>
  <li>Demonstrate concepts behind OLAP, financial close, and last-mile reporting</li>
</ul>

<h2>Tech Stack</h2>
<ul>
  <li><strong>Data Source:</strong> Public General Ledger data (State of Oklahoma, FY2024)</li>
  <li><strong>ETL / Database:</strong> SQL Server Express, T-SQL, Python</li>
  <li><strong>Data Model:</strong> Star schema (Fact + Dimensions) in <code>dw</code> schema</li>
  <li><strong>Reporting:</strong> Power BI Desktop</li>
</ul>

<h2>Source Data</h2>
<p>
The raw file <code>ledger_fy24_qtr3.csv</code> contains a statewide General Ledger extract, similar to data provided by ERPs
or subledgers to enterprise close tools.
</p>

<h3>Key Fields</h3>

<h4>Time</h4>
<ul>
  <li>FISCAL_YEAR</li>
  <li>ACCOUNTING_PERIOD</li>
</ul>

<h4>Entity / Fund</h4>
<ul>
  <li>AGENCYNBR</li>
  <li>AGENCYNAME</li>
  <li>FUND_CODE</li>
  <li>FUNDDESCR</li>
  <li>CLASS_FLD</li>
  <li>CLASSDESCR</li>
</ul>

<h4>Chartfields</h4>
<ul>
  <li>ACCOUNT, ACCTDESCR</li>
  <li>DEPTID, DEPTDESCR</li>
  <li>OPERATING_UNIT</li>
  <li>PROGRAM_CODE</li>
  <li>PRODUCT</li>
  <li>PROJECT_ID</li>
  <li>ACTIVITY</li>
  <li>Additional chartfield attributes</li>
</ul>

<h4>Measure</h4>
<ul>
  <li>POSTED_TOTAL_AMT – posted balance per chartfield combination</li>
</ul>

<p>
This structure closely mimics how data is landed into Workiva Wdata or Longview Close from upstream systems.
</p>

<h2>Staging Layer</h2>
<p>
The raw GL file is first loaded into a staging table in SQL Server.
</p>

<h3>Characteristics</h3>
<ul>
  <li>Mirrors the source structure almost one-to-one</li>
  <li>All fields stored as text except the amount</li>
  <li>Loaded via Python ETL</li>
  <li>Represents a raw feed before business logic or modeling</li>
</ul>

<p>
This stage simulates the initial landing zone used by enterprise financial systems.
</p>

<h2>Dimensional Model (Star Schema)</h2>
<p>
The staging data is reshaped into a star schema in the <code>dw</code> schema to support OLAP-style analysis and reporting.
</p>

<h3>Fact Table</h3>
<h4>dw.FactGL</h4>

<h5>Grain</h5>
<p>
One row per combination of fiscal year, accounting period, fund, account, department, and other chartfields.
</p>

<h5>Key Columns</h5>
<ul>
  <li>TimeKey → dw.DimTime</li>
  <li>FundKey → dw.DimFund</li>
  <li>AccountKey → dw.DimAccount</li>
  <li>DeptKey → dw.DimDept</li>
  <li>PostedTotalAmt (numeric measure)</li>
</ul>

<h3>Dimension Tables</h3>
<ul>
  <li>
    <strong>dw.DimTime</strong> – Fiscal calendar (year, period, quarter, labels)
  </li>
  <li>
    <strong>dw.DimFund</strong> – Funds (proxy for entity or line of business)
  </li>
  <li>
    <strong>dw.DimAccount</strong> – Chart of accounts with descriptions and high-level type
    (Asset / Liability / Revenue / Expense)
  </li>
  <li>
    <strong>dw.DimDept</strong> – Departments / cost centers
  </li>
</ul>

<p>
This modeling pattern is standard in financial OLAP cubes and conceptually mirrors the internal structures used by
Longview Close.
</p>

<h2>Relation to OLAP and Longview Close</h2>
<ul>
  <li>Star schemas enable fast aggregations, slicing, and drill-downs</li>
  <li>Financial systems organize data by entity, account, and time</li>
  <li>Longview Close performs consolidations on top of multi-dimensional structures</li>
</ul>

<p>
In this project, SQL Server and Power BI together act as a lightweight OLAP layer similar to what Longview would provide
in a production environment.
</p>

<h2>Reporting and Last-Mile View (Power BI and Workiva)</h2>

<h3>Power BI Data Model</h3>
<p>Imported tables:</p>
<ul>
  <li>dw.FactGL</li>
  <li>dw.DimTime</li>
  <li>dw.DimFund</li>
  <li>dw.DimAccount</li>
  <li>dw.DimDept</li>
</ul>

<h4>Relationships</h4>
<ul>
  <li>One-to-many from each dimension to FactGL</li>
  <li>Single-direction filters from dimensions to fact table</li>
</ul>

<h3>P&amp;L-Style Matrix</h3>

<h4>Visual Setup</h4>
<ul>
  <li><strong>Rows:</strong> DimAccount[AccountDescr]</li>
  <li><strong>Columns:</strong> DimTime[YearPeriodLabel] (e.g., 2024-P7, 2024-P8)</li>
  <li><strong>Values:</strong> SUM(FactGL[PostedTotalAmt]), formatted as currency</li>
  <li><strong>Slicers:</strong> Fund (DimFund[FundDescr]), Department (DimDept[DeptDescr])</li>
</ul>

<h4>User Capabilities</h4>
<ul>
  <li>Slice P&amp;L by fund (entity or business unit)</li>
  <li>Filter by department (cost center)</li>
  <li>View period-by-period totals and grand totals</li>
</ul>

<h2>Relation to Workiva</h2>
<p>
Workiva provides centralized datasets, query-based joins and aggregations, and linked reports that always reflect
refreshed data.
</p>

<p>
In this project:
</p>
<ul>
  <li>The <code>dw.*</code> tables act as Wdata tables</li>
  <li>The Power BI model mirrors Workiva queries and linked reports</li>
  <li>The P&amp;L matrix represents a last-mile financial statement used during close</li>
</ul>

<h2>Summary</h2>
<p>
FinanceClose demonstrates how raw General Ledger data flows into a centralized platform, is reshaped into a
dimensional model, and supports fast, interactive financial reporting. The project mirrors enterprise close
and reporting workflows and highlights core concepts in financial systems, OLAP modeling, and last-mile reporting.
</p>
