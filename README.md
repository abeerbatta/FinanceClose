<h2>Finance Close Analytics – GL to OLAP P&amp;L</h2>
<p>
  This project simulates a mini financial close and reporting pipeline using a real
  General Ledger extract from the State of Oklahoma. It loads raw GL data into
  SQL Server, models it into a star schema, and surfaces an interactive P&amp;L
  report in Power BI—mirroring how enterprise tools like Longview Close and
  Workiva’s Wdata support “last-mile” financial reporting.
</p>

<h3>Repository contents</h3>
<ul>
  <li><code>data/</code> Source: https://catalog.data.gov/dataset/general-ledger/resource/19febcf5-8baa-4c1b-bb75-c76d25071e01?inner_span=True </li>
  <li>Public GL CSV/Excel files used as the source system.</li>
  <li><code>sql/createstg.sql</code> – Creates <code>stg</code> and <code>dw</code> schemas and all tables (staging + star schema).</li>
  <li><code>sql/createdwschema.sql</code> – Populates <code>DimTime</code>, <code>DimFund</code>, <code>DimAccount</code>, <code>DimDept</code> from the staging table.</li>
  <li><code>sql/populatestg.sql</code> – Populates <code>FactGL</code> with surrogate keys and numeric measures.</li>
  <li><code>sql/populatedw.sql</code> – Populates stg table with data.</li>
  <li><code>FinanceCloseDemo.pbix</code> – Power BI report with the P&amp;L-style matrix and slicers.</li>
  <li><code>docs/erd.png</code> – Star schema diagram (FactGL + dimensions).</li>
  <li><code>docs/report_pnl.png</code> – Screenshot of the P&amp;L matrix with fund/department slicers.</li>
</ul>

<h3>Data flow</h3>
<ol>
  <li><strong>Source → Staging</strong>: A public GL extract (fiscal year, period, fund, account, department, posted amount) is loaded into <code>stg.GeneralLedgerRaw</code> in SQL Server.</li>
  <li><strong>Staging → Star schema</strong>: T‑SQL scripts cleanse and reshape the data into a dimensional model:
    <ul>
      <li><code>DimTime</code> – fiscal year, accounting period, quarter, period label.</li>
      <li><code>DimFund</code> – fund code and description (proxy for entity/line of business).</li>
      <li><code>DimAccount</code> – chart of accounts and descriptions.</li>
      <li><code>DimDept</code> – departments / cost centers.</li>
      <li><code>FactGL</code> – ~1.3M rows linking to all dimensions via surrogate keys with <code>PostedTotalAmt</code> as the main measure.</li>
    </ul>
  </li>
  <li><strong>Star schema → Power BI</strong>: The star schema is imported into Power BI Desktop. Relationships are defined as one‑to‑many from each dimension to <code>FactGL</code>, matching OLAP best practices.</li>
</ol>

<h3>P&amp;L report</h3>
<p>
  The main visual is a P&amp;L-style matrix:
</p>
<ul>
  <li><strong>Rows</strong>: <code>DimAccount.AccountDescr</code></li>
  <li><strong>Columns</strong>: <code>DimTime.YearPeriodLabel</code> (e.g., 2024‑P7, 2024‑P8, 2024‑P9)</li>
  <li><strong>Values</strong>: <code>SUM(FactGL.PostedTotalAmt)</code> (formatted as currency)</li>
  <li><strong>Slicers</strong>: <code>DimFund.FundDescr</code> and <code>DimDept.DeptDescr</code> to slice the P&amp;L by fund and department</li>
</ul>
<p>
  This replicates an OLAP-style income statement where finance users can slice, filter, and drill into results across periods, funds, and departments.
</p>

<h3>Relation to Longview Close, Workiva, and OLAP</h3>
<ul>
  <li><strong>OLAP / Star schema</strong>: The <code>FactGL</code> + dimension design follows classic star-schema modelling used for OLAP cubes, enabling fast aggregations and multi-dimensional analysis.</li>
  <li><strong>Longview Close</strong>: Longview Close ingests GL data, organizes it by entity, account, and time, and performs consolidation on a similar multi-dimensional model. This project reproduces that data structure on a smaller scale and shows how consolidated P&amp;L reporting can be built on top.</li>
  <li><strong>Workiva Wdata</strong>: The <code>dw</code> tables act like Wdata tables. The joins and aggregations in Power BI are analogous to Workiva queries that feed connected spreadsheets and narrative reports for “last‑mile” financial reporting.</li>
</ul>

<h3>What this demonstrates</h3>
<ul>
  <li>End‑to‑end understanding of how GL data moves from raw extracts through staging and cleansing into an OLAP‑friendly star schema.</li>
  <li>Ability to design and implement dimensional models (fact + dimensions) suitable for consolidation and reporting platforms such as Longview Close.</li>
  <li>Hands‑on experience connecting SQL Server to Power BI and building P&amp;L-style, pivot‑like analytics with fund and department slicers.</li>
</ul>
