const express = require('express');
const cors    = require('cors');
const db      = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// ── GET all countries ─────────────────────────────────────────
app.get('/api/countries', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT country_id, country_name, region FROM country ORDER BY country_name'
    );
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── GET all sites for one country ─────────────────────────────
app.get('/api/sites/:countryId', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT hs.site_id, hs.site_name, hc.category_name,
              hs.inscription_year, hs.area_hectares,
              hs.outstanding_value, hs.is_endangered
       FROM heritagesite hs
       JOIN heritagecategory hc ON hs.category_id = hc.category_id
       WHERE hs.country_id = ?`,
      [req.params.countryId]
    );
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── GET full detail for one site ──────────────────────────────
app.get('/api/site/:id', async (req, res) => {
  const siteId = req.params.id;
  try {
    const [siteRows] = await db.query(`
      SELECT hs.*, c.country_name, c.region, hc.category_name
      FROM heritagesite    hs
      JOIN country          c  ON hs.country_id  = c.country_id
      JOIN heritagecategory hc ON hs.category_id = hc.category_id
      WHERE hs.site_id = ?
    `, [siteId]);
    if (!siteRows.length) return res.status(404).json({ error: 'Not found' });
    const site = siteRows[0];

    const [visitors] = await db.query(`
      SELECT report_year, visitor_count, total_revenue, conservation_spend
      FROM annualreport WHERE site_id = ? ORDER BY report_year ASC
    `, [siteId]);

    let total_funding = null;
    try {
      const [f] = await db.query(`SELECT SUM(amount_usd) AS total_funding FROM fundingallocation WHERE site_id = ?`, [siteId]);
      total_funding = f[0]?.total_funding ?? null;
    } catch (_) {}

    let threats = [];
    try {
      const [t] = await db.query(`
        SELECT ti.description, ti.severity, ti.resolved, tc.category_name
        FROM threatincident ti
        JOIN threatcategory tc ON ti.threat_cat_id = tc.threat_cat_id
        WHERE ti.site_id = ? ORDER BY ti.incident_date DESC
      `, [siteId]);
      threats = t;
    } catch (_) {}

    let zones = [];
    try {
      const [z] = await db.query(`SELECT zone_name, zone_type, area_hectares FROM sitezone WHERE site_id = ?`, [siteId]);
      zones = z;
    } catch (_) {}

    res.json({ ...site, visitors, total_funding, threats, conservation: null, zones });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ════════════════════════════════════════════════════════════════
// ANALYTICS QUERY ROUTES
// ════════════════════════════════════════════════════════════════

// Q1: Full site listing
app.get('/api/analytics/q1', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_id, hs.site_name, c.country_name, c.region,
             hc.category_name, hs.inscription_year, hs.area_hectares,
             IF(hs.is_endangered,'YES','NO') AS on_danger_list
      FROM heritagesite hs
      JOIN country c           ON hs.country_id  = c.country_id
      JOIN heritagecategory hc ON hs.category_id = hc.category_id
      ORDER BY hs.inscription_year
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q2: Endangered sites with latest conservation status
app.get('/api/analytics/q2', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name, cs.status_label, cs.risk_level,
             cr.assessment_date, cr.notes
      FROM heritagesite hs
      JOIN country c             ON hs.country_id = c.country_id
      JOIN conservationrecord cr ON hs.site_id    = cr.site_id
      JOIN conservationstatus cs ON cr.status_id  = cs.status_id
      WHERE hs.is_endangered = 1
        AND cr.assessment_date = (
          SELECT MAX(cr2.assessment_date) FROM conservationrecord cr2
          WHERE cr2.site_id = hs.site_id
        )
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q3: Total visitors and revenue per site
app.get('/api/analytics/q3', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name,
             COUNT(v.visit_id) AS total_visits,
             SUM(v.group_size) AS total_visitors,
             SUM(v.revenue_usd) AS total_revenue_usd,
             ROUND(AVG(v.feedback_score),2) AS avg_feedback
      FROM heritagesite hs
      JOIN country c ON hs.country_id = c.country_id
      LEFT JOIN visit v ON hs.site_id = v.site_id
      GROUP BY hs.site_id, hs.site_name, c.country_name
      ORDER BY total_revenue_usd DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q6: Open HIGH/CRITICAL threat incidents
app.get('/api/analytics/q4', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT ti.incident_id, hs.site_name, c.country_name,
             tc.category_name AS threat_type, ti.severity,
             ti.incident_date, ti.description
      FROM threatincident ti
      JOIN heritagesite hs   ON ti.site_id       = hs.site_id
      JOIN country c         ON hs.country_id    = c.country_id
      JOIN threatcategory tc ON ti.threat_cat_id = tc.threat_cat_id
      WHERE ti.resolved = 0 AND ti.severity IN ('High','Critical')
      ORDER BY ti.severity DESC, ti.incident_date
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q7: Threat incidents by type — count & resolution rate
app.get('/api/analytics/q5', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT tc.category_name,
             COUNT(*) AS total_incidents,
             SUM(ti.resolved) AS resolved_count,
             COUNT(*) - SUM(ti.resolved) AS open_count,
             ROUND(SUM(ti.resolved)/COUNT(*)*100,1) AS resolution_rate_pct
      FROM threatincident ti
      JOIN threatcategory tc ON ti.threat_cat_id = tc.threat_cat_id
      GROUP BY tc.category_name
      ORDER BY total_incidents DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q8: Total funding per site
app.get('/api/analytics/q6', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name,
             COUNT(fa.allocation_id) AS funding_tranches,
             SUM(fa.amount_usd) AS total_funded_usd
      FROM fundingallocation fa
      JOIN heritagesite hs ON fa.site_id    = hs.site_id
      JOIN country c       ON hs.country_id = c.country_id
      GROUP BY hs.site_id, hs.site_name, c.country_name
      ORDER BY total_funded_usd DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q9: Funding by source type and fiscal year
app.get('/api/analytics/q7', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT fs.source_type, fa.fiscal_year,
             COUNT(fa.allocation_id) AS allocations,
             SUM(fa.amount_usd) AS total_amount_usd
      FROM fundingallocation fa
      JOIN fundingsource fs ON fa.fund_id = fs.fund_id
      GROUP BY fs.source_type, fa.fiscal_year
      ORDER BY fa.fiscal_year, total_amount_usd DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q11: Sites with Critical or Fair conservation status
app.get('/api/analytics/q8', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name, cs.status_label, cr.assessment_date
      FROM heritagesite hs
      JOIN country c             ON hs.country_id = c.country_id
      JOIN conservationrecord cr ON hs.site_id    = cr.site_id
      JOIN conservationstatus cs ON cr.status_id  = cs.status_id
      WHERE cr.assessment_date = (
        SELECT MAX(cr2.assessment_date) FROM conservationrecord cr2 WHERE cr2.site_id = hs.site_id
      ) AND cs.status_label IN ('Critical','Fair')
      ORDER BY cs.risk_level DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q12: Top 5 sites by visitor revenue
app.get('/api/analytics/q9', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, SUM(v.revenue_usd) AS total_revenue
      FROM visit v
      JOIN heritagesite hs ON v.site_id = hs.site_id
      GROUP BY hs.site_id, hs.site_name
      ORDER BY total_revenue DESC LIMIT 5
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q13: Monthly visit trend for 2023
app.get('/api/analytics/q10', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT YEAR(visit_date) AS yr, MONTH(visit_date) AS mth,
             MONTHNAME(visit_date) AS month_name,
             COUNT(visit_id) AS visit_count,
             SUM(group_size) AS visitors,
             SUM(revenue_usd) AS revenue_usd
      FROM visit WHERE YEAR(visit_date) = 2023
      GROUP BY yr, mth, month_name ORDER BY mth
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q15: Visitors who visited more than one site
app.get('/api/analytics/q11', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT v.full_name, v.nationality,
             COUNT(DISTINCT vi.site_id) AS sites_visited,
             COUNT(vi.visit_id) AS total_visits,
             SUM(vi.revenue_usd) AS total_spent_usd
      FROM visitor v
      JOIN visit vi ON v.visitor_id = vi.visitor_id
      WHERE v.visitor_id IN (
        SELECT visitor_id FROM visit GROUP BY visitor_id HAVING COUNT(DISTINCT site_id) > 1
      )
      GROUP BY v.visitor_id, v.full_name, v.nationality
      ORDER BY sites_visited DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q17: Sites with NO threat incidents
app.get('/api/analytics/q12', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name, hc.category_name, hs.inscription_year
      FROM heritagesite hs
      JOIN country c           ON hs.country_id  = c.country_id
      JOIN heritagecategory hc ON hs.category_id = hc.category_id
      WHERE hs.site_id NOT IN (SELECT DISTINCT site_id FROM threatincident)
      ORDER BY hs.site_name
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q18: Complete funding picture per project
app.get('/api/analytics/q13', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT cp.project_name, hs.site_name, fs.source_name,
             fs.source_type, fa.amount_usd, fa.fiscal_year
      FROM fundingallocation fa
      JOIN conservationproject cp ON fa.project_id = cp.project_id
      JOIN heritagesite hs        ON fa.site_id    = hs.site_id
      JOIN fundingsource fs       ON fa.fund_id    = fs.fund_id
      ORDER BY cp.project_name, fa.fiscal_year
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q19: Annual report summary
app.get('/api/analytics/q14', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, ar.report_year, ar.visitor_count,
             ar.total_revenue, ar.conservation_spend,
             ROUND(ar.conservation_spend / ar.total_revenue * 100, 1) AS conservation_as_pct_revenue,
             ar.summary
      FROM annualreport ar
      JOIN heritagesite hs ON ar.site_id = hs.site_id
      ORDER BY hs.site_name, ar.report_year
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q20: Zone inventory per site
app.get('/api/analytics/q15', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, sz.zone_name, sz.zone_type,
             sz.area_hectares,
             ROUND(sz.area_hectares / hs.area_hectares * 100, 2) AS pct_of_total_area
      FROM sitezone sz
      JOIN heritagesite hs ON sz.site_id = hs.site_id
      ORDER BY hs.site_name, sz.zone_type
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q21: Threat hotspots — sites with 3+ incidents
app.get('/api/analytics/q16', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name,
             COUNT(ti.incident_id) AS total_incidents,
             SUM(ti.resolved) AS resolved,
             COUNT(ti.incident_id)-SUM(ti.resolved) AS open_incidents,
             GROUP_CONCAT(DISTINCT tc.category_name ORDER BY tc.category_name SEPARATOR ', ') AS threat_types
      FROM threatincident ti
      JOIN heritagesite hs   ON ti.site_id       = hs.site_id
      JOIN country c         ON hs.country_id    = c.country_id
      JOIN threatcategory tc ON ti.threat_cat_id = tc.threat_cat_id
      GROUP BY hs.site_id, hs.site_name, c.country_name
      HAVING total_incidents >= 3
      ORDER BY total_incidents DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q23: Low feedback sites
app.get('/api/analytics/q17', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name,
             ROUND(AVG(v.feedback_score),2) AS avg_feedback,
             COUNT(v.visit_id) AS total_reviews
      FROM visit v
      JOIN heritagesite hs ON v.site_id     = hs.site_id
      JOIN country c       ON hs.country_id = c.country_id
      WHERE v.feedback_score IS NOT NULL
      GROUP BY hs.site_id, hs.site_name, c.country_name
      HAVING avg_feedback < 4.0
      ORDER BY avg_feedback ASC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q24: Sites due for conservation re-assessment in 6 months
app.get('/api/analytics/q18', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, cr.assessment_date AS last_assessed,
             cr.next_review, cs.status_label,
             DATEDIFF(cr.next_review, CURDATE()) AS days_until_review
      FROM conservationrecord cr
      JOIN heritagesite hs     ON cr.site_id   = hs.site_id
      JOIN conservationstatus cs ON cr.status_id = cs.status_id
      WHERE cr.next_review BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
      ORDER BY cr.next_review
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Q25: Executive dashboard
app.get('/api/analytics/q19', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT hs.site_name, c.country_name, hc.category_name,
             hs.inscription_year,
             IF(hs.is_endangered,'Endangered','Safe') AS danger_status,
             cs_latest.status_label AS conservation_status,
             COALESCE(SUM(DISTINCT fa.amount_usd),0) AS total_funding_usd,
             COALESCE(visit_agg.total_visitors,0) AS total_visitors,
             COALESCE(threat_agg.open_threats,0) AS open_threats,
             COALESCE(project_agg.active_projects,0) AS active_projects
      FROM heritagesite hs
      JOIN country c               ON hs.country_id  = c.country_id
      JOIN heritagecategory hc     ON hs.category_id = hc.category_id
      JOIN conservationrecord cr   ON hs.site_id     = cr.site_id
        AND cr.assessment_date = (
          SELECT MAX(cr2.assessment_date) FROM conservationrecord cr2 WHERE cr2.site_id = hs.site_id
        )
      JOIN conservationstatus cs_latest ON cr.status_id = cs_latest.status_id
      LEFT JOIN fundingallocation fa ON fa.site_id = hs.site_id
      LEFT JOIN (
        SELECT site_id, SUM(group_size) AS total_visitors FROM visit GROUP BY site_id
      ) visit_agg ON visit_agg.site_id = hs.site_id
      LEFT JOIN (
        SELECT site_id, COUNT(*) AS open_threats FROM threatincident WHERE resolved=0 GROUP BY site_id
      ) threat_agg ON threat_agg.site_id = hs.site_id
      LEFT JOIN (
        SELECT site_id, COUNT(*) AS active_projects FROM conservationproject WHERE status='Ongoing' GROUP BY site_id
      ) project_agg ON project_agg.site_id = hs.site_id
      GROUP BY hs.site_id, hs.site_name, c.country_name, hc.category_name,
               hs.inscription_year, hs.is_endangered, cs_latest.status_label,
               visit_agg.total_visitors, threat_agg.open_threats, project_agg.active_projects
      ORDER BY open_threats DESC, hs.site_name
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});
// Add this inside your app.get('/api/analytics/:id') switch block in server.js
app.get('/api/analytics/q20', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        cp.project_id,
        cp.project_name,
        hs.site_name,
        cp.status AS project_status,
        cp.budget_usd AS planned_budget_usd,
        COALESCE(SUM(fa.amount_usd), 0) AS total_allocated_usd,
        cp.budget_usd - COALESCE(SUM(fa.amount_usd), 0) AS funding_gap_usd,
        CASE 
          WHEN cp.budget_usd > 0 THEN ROUND((COALESCE(SUM(fa.amount_usd), 0) / cp.budget_usd) * 100, 1)
          ELSE 0.0
        END AS coverage_pct
      FROM conservationproject cp
      JOIN heritagesite hs ON cp.site_id = hs.site_id
      LEFT JOIN fundingallocation fa ON cp.project_id = fa.project_id
      GROUP BY cp.project_id, cp.project_name, hs.site_name, cp.status, cp.budget_usd
      ORDER BY funding_gap_usd DESC
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── GET threat heatmap ────────────────────────────────────────
app.get('/api/heatmap', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT c.country_name, tc.category_name AS threat_type,
             MAX(ti.severity) AS max_severity
      FROM threatincident ti
      JOIN threatcategory tc ON ti.threat_cat_id = tc.threat_cat_id
      JOIN heritagesite hs   ON ti.site_id       = hs.site_id
      JOIN country c         ON hs.country_id    = c.country_id
      GROUP BY c.country_name, tc.category_name
      ORDER BY c.country_name, tc.category_name
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.listen(3000, () => console.log('✓ Server running on http://localhost:3000'));