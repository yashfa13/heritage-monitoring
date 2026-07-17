/* ── Config ────────────────────────────────────────────────────*/
const API = 'http://localhost:3000/api';

/* ── Country appearance ─────────────────────────────────────── */
const COUNTRY_META = {
  'Italy':          { img:'images/italy.webp' },
  'China':          { img:'images/an illustration of a great wall of china.jpeg' },
  'India':          { img:'images/india.webp' },
  'Pakistan':       { img:'images/pakistan_download.jpeg' },
  'Peru':           { img:'images/Coffee Bean and Tea Leaf _ Illustrated Coffee Labels — Down the Street Designs.jpeg' },
  'Egypt':          { img:'images/Egyptian pyramids in the desert_ Vector illustration of a flat design_.jpeg' },
  'Mexico':         { img:'images/Mexico.jpeg' },
  'Japan':          { img:'images/japan_1144758799036208314.jpeg' },
  'Brazil':         { img:'images/brazil_7177680650558214.jpeg' },
  'Jordan':         { img:'images/jordan5066618327105828.jpeg' },
  'Kenya':          { img:'images/target - Tiphaine Creative Talents.jpeg' },
  'United Kingdom': { img:'images/uk1060738518504762442.jpeg' },
  'Germany':        { img:'images/germany_101049585388890071.jpeg' },
  'France':         { img:'images/Paris • France_.jpeg' },
  'Spain':          { img:'images/Wall Art Print – Ibiza, Spain, Graphic Illustration 2.jpeg' },
};

/* ── Site background images ──────────────────────────────────── */
const SITE_IMAGES = {
  1:  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Colosseo_2020.jpg/1280px-Colosseo_2020.jpg',
  2:  'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image-Venice.jpg/1280px-Image-Venice.jpg',
  3:  'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Firenze_duomo.jpg/1280px-Firenze_duomo.jpg',
  4:  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Mutianyu_Great_Wall.jpg/1280px-Mutianyu_Great_Wall.jpg',
  5:  'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Forbidden_City_Beijing_Shenwumen_Gate.jpg/1280px-Forbidden_City_Beijing_Shenwumen_Gate.jpg',
  6:  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Jiuzhaigou_Shuzheng_Valley1.jpg/1280px-Jiuzhaigou_Shuzheng_Valley1.jpg',
  7:  'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Taj_Mahal%2C_Agra%2C_India_edit3.jpg/1280px-Taj_Mahal%2C_Agra%2C_India_edit3.jpg',
  8:  'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Hampi1.jpg/1280px-Hampi1.jpg',
  9:  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/One-horned_Rhino_at_Kaziranga.jpg/1280px-One-horned_Rhino_at_Kaziranga.jpg',
  10: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Mohenjodaro_Sindh.jpg/1280px-Mohenjodaro_Sindh.jpg',
  11: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Taxila_Museum.jpg/1280px-Taxila_Museum.jpg',
  12: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Lahore_Fort_Sheesh_Mahal.jpg/1280px-Lahore_Fort_Sheesh_Mahal.jpg',
  13: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Machu_Picchu%2C_Peru.jpg/1280px-Machu_Picchu%2C_Peru.jpg',
  14: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Alpamayo.jpg/1280px-Alpamayo.jpg',
  15: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chan_Chan_aerial.jpg/1280px-Chan_Chan_aerial.jpg',
  16: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Kheops-Pyramid.jpg/1280px-Kheops-Pyramid.jpg',
  17: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Karnak_temple.jpg/1280px-Karnak_temple.jpg',
  18: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Abu_Simbel_Temple.jpg/1280px-Abu_Simbel_Temple.jpg',
  19: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/ChichenItza.jpg/1280px-ChichenItza.jpg',
  20: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Mexico_City_Cathedral.jpg/1280px-Mexico_City_Cathedral.jpg',
  21: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Sian_Ka%27an.jpg/1280px-Sian_Ka%27an.jpg',
  22: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Todaiji18s3200.jpg/1280px-Todaiji18s3200.jpg',
  23: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Hiroshima_Peace_Memorial.jpg/1280px-Hiroshima_Peace_Memorial.jpg',
  24: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Shirakami-Sanchi.jpg/1280px-Shirakami-Sanchi.jpg',
  25: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Amazon_manaus_forest.jpg/1280px-Amazon_manaus_forest.jpg',
  26: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Iguacu_Argentina.jpg/1280px-Iguacu_Argentina.jpg',
  27: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Ouro_Preto_vista.jpg/1280px-Ouro_Preto_vista.jpg',
  28: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Petra_Jordan_BW_21.jpg/1280px-Petra_Jordan_BW_21.jpg',
  29: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Quseir_Amra-Badib.jpg/1280px-Quseir_Amra-Badib.jpg',
  30: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Wadi_Rum_Valley.jpg/1280px-Wadi_Rum_Valley.jpg',
  31: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Mount_Kenya.jpg/1280px-Mount_Kenya.jpg',
  32: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Lake_Turkana_1.jpg/1280px-Lake_Turkana_1.jpg',
  33: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Lamu_Island.jpg/1280px-Lamu_Island.jpg',
  34: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Stonehenge2007_07_30.jpg/1280px-Stonehenge2007_07_30.jpg',
  35: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Tower_of_London_viewed_from_the_River_Thames.jpg/1280px-Tower_of_London_viewed_from_the_River_Thames.jpg',
  36: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Giant%27s_Causeway_closeup.jpg/1280px-Giant%27s_Causeway_closeup.jpg',
  37: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Cologne_Germany_Cologne-Cathedral-01.jpg/1280px-Cologne_Germany_Cologne-Cathedral-01.jpg',
  38: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Sanssouci_garden.jpg/1280px-Sanssouci_garden.jpg',
  39: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Messel_open_pit_mine.jpg/1280px-Messel_open_pit_mine.jpg',
  40: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Mont_Saint-Michel_3%2C_Brittany%2C_France_-_July_2011.jpg/1280px-Mont_Saint-Michel_3%2C_Brittany%2C_France_-_July_2011.jpg',
  41: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Versailles_chateau_exterieur.jpg/1280px-Versailles_chateau_exterieur.jpg',
  42: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Lascaux_painting.jpg/1280px-Lascaux_painting.jpg',
  43: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Alhambra%2C_Granada%2C_Spain.jpg/1280px-Alhambra%2C_Granada%2C_Spain.jpg',
  44: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Sagrada_Familia_01.jpg/1280px-Sagrada_Familia_01.jpg',
  45: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Donana_National_Park.jpg/1280px-Donana_National_Park.jpg',
};

/* ── State ───────────────────────────────────────────────────── */
let countries       = [];
let selectedCountry = null;
let selectedSiteId  = null;
let visitorChart    = null;
let budgetChart     = null;

/* ── Boot ────────────────────────────────────────────────────── */
(async () => {
  try {
    const res = await fetch(`${API}/countries`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    countries = await res.json();

    // Render the scroller cards now that countries array is populated
    renderCountryGrid();
    initCountryScroller();

    // Auto-select first country using its numeric ID
    if (countries.length) {
      await selectCountry(countries[0].country_id);
    }
  } catch (err) {
    document.getElementById('countryGrid').innerHTML =
      `<div class="err-box" style="grid-column:1/-1">
        ⚠ Backend unreachable — run <strong>node server.js</strong> in PowerShell.<br>
        <small>${err.message}</small>
      </div>`;
  }
})();

/* ── Render country grid ─────────────────────────────────────── */
function renderCountryGrid() {
  const track = document.querySelector('.country-track');
  if (!track) return;
  track.innerHTML = '';

  Object.keys(COUNTRY_META).forEach(countryName => {
    const countryData = COUNTRY_META[countryName];

    // Match display name to the DB record to get the real numeric country_id
    const countryRecord = countries.find(
      c => c.country_name.toLowerCase() === countryName.toLowerCase()
    );
    if (!countryRecord) return; // skip if country not returned by API

    const card = document.createElement('div');
    card.className = 'country-card';
    card.dataset.countryId = countryRecord.country_id; // store ID on the element

    // ✅ Pass numeric country_id — NOT the name string
    card.onclick = () => selectCountry(countryRecord.country_id);

    card.innerHTML = `
      <div class="country-img-wrap">
        <img src="${countryData.img}" alt="${countryName} illustration" class="country-tab-img">
      </div>
      <div class="country-info-label">
        <span class="c-name">${countryName}</span>
      </div>
    `;

    track.appendChild(card);
  });

  // Re-apply active highlight after re-render
  updateActiveCard();
}

/* ── Update active card highlight ───────────────────────────── */
function updateActiveCard() {
  document.querySelectorAll('.country-card').forEach(card => {
    const isActive = selectedCountry &&
      parseInt(card.dataset.countryId) === selectedCountry.country_id;
    card.classList.toggle('active', isActive);
  });
}

/* ── Init horizontal scroller arrows ────────────────────────── */
function initCountryScroller() {
  const track   = document.querySelector('.country-track');
  const btnPrev = document.querySelector('.scroll-btn.prev');
  const btnNext = document.querySelector('.scroll-btn.next');

  if (!track || !btnPrev || !btnNext) return;

  const SCROLL_BY = 160 * 3; // scroll 3 cards at a time

  function updateArrows() {
    const atStart = track.scrollLeft <= 4;
    const atEnd   = track.scrollLeft + track.clientWidth >= track.scrollWidth - 4;
    btnPrev.classList.toggle('hidden', atStart);
    btnNext.classList.toggle('hidden', atEnd);
  }

  btnPrev.addEventListener('click', () => {
    track.scrollBy({ left: -SCROLL_BY, behavior: 'smooth' });
  });
  btnNext.addEventListener('click', () => {
    track.scrollBy({ left: SCROLL_BY, behavior: 'smooth' });
  });

  track.addEventListener('scroll', updateArrows, { passive: true });

  updateArrows(); // hide prev arrow on load
}

/* ── Select country ──────────────────────────────────────────── */
async function selectCountry(countryId) {
  // countryId is always a numeric ID here
  selectedCountry = countries.find(c => c.country_id === countryId);
  if (!selectedCountry) return;

  selectedSiteId = null;

  // Update active card highlight WITHOUT re-rendering the whole grid
  updateActiveCard();

  // Hide detail panel
  document.getElementById('detailSection').style.display = 'none';
  document.getElementById('detailPanel').innerHTML = '';

  // Show sites section and load sites
  const sitesSection = document.getElementById('sitesSection');
  sitesSection.style.display = 'block';
  document.getElementById('sitesLabel').textContent =
    `${selectedCountry.country_name} · Heritage Sites`;
  document.getElementById('sitesRow').innerHTML =
    `<div class="no-data">Loading…</div>`;

  try {
    const res = await fetch(`${API}/sites/${countryId}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const sites = await res.json();

    if (!sites.length) {
      document.getElementById('sitesRow').innerHTML =
        `<div class="no-data">No sites found.</div>`;
      return;
    }

    document.getElementById('sitesRow').innerHTML = sites.map(s => {
      const imgUrl = SITE_IMAGES[s.site_id] || '';
      const catKey = (s.category_name || 'Cultural').toLowerCase();
      // Use background-image on the card element instead of an <img> tag.
      // CSS backgrounds bypass the CORS/hotlinking restriction that causes
      // Wikimedia URLs to fail silently when loaded via <img> cross-origin.
      const bgStyle = imgUrl
        ? `style="background-image:url('${imgUrl}');background-size:cover;background-position:center"`
        : '';
      return `
        <div class="site-card" onclick="selectSite(${s.site_id}, this)" ${bgStyle}>
          <div class="site-card-gradient"></div>
          <div class="site-card-body">
            <span class="site-cat-pill pill-${catKey}">${s.category_name || 'Cultural'}</span>
            <div class="site-card-name">${s.site_name}</div>
            <div class="site-card-year">Inscribed ${s.inscription_year}</div>
          </div>
          ${s.is_endangered
            ? '<div class="site-endangered-dot" title="UNESCO Endangered List"></div>'
            : ''}
        </div>`;
    }).join('');

    sitesSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

  } catch (err) {
    document.getElementById('sitesRow').innerHTML =
      `<div class="err-box">Could not load sites: ${err.message}</div>`;
  }
}

/* ── Select site ─────────────────────────────────────────────── */
async function selectSite(siteId, cardEl) {
  selectedSiteId = siteId;
  document.querySelectorAll('.site-card').forEach(c => c.classList.remove('active'));
  if (cardEl) cardEl.classList.add('active');

  const detailSection = document.getElementById('detailSection');
  const panel         = document.getElementById('detailPanel');
  detailSection.style.display = 'block';
  panel.innerHTML = `<div class="no-data" style="padding:2rem 0">Loading site data…</div>`;
  detailSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

  try {
    const res  = await fetch(`${API}/site/${siteId}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const site = await res.json();
    site.latitude  = site.latitude  != null ? parseFloat(site.latitude)  : null;
    site.longitude = site.longitude != null ? parseFloat(site.longitude) : null;
    renderDetail(site);
  } catch (err) {
    panel.innerHTML = `<div class="err-box">Could not load detail: ${err.message}</div>`;
  }
}

/* ── Render detail ───────────────────────────────────────────── */
function renderDetail(site) {
  const panel      = document.getElementById('detailPanel');
  const imgUrl     = SITE_IMAGES[site.site_id] || '';
  const riskLevel  = site.conservation?.risk_level || 2;
  const riskLabel  = site.conservation?.status_label || 'Good';
  const statusClass = { 1:'ds-excellent', 2:'ds-good', 3:'ds-fair', 4:'ds-critical' }[riskLevel] || 'ds-good';

  const latest = site.visitors?.slice(-1)[0] || null;
  const fmt    = n => n >= 1e6 ? (n/1e6).toFixed(1)+'M' : n >= 1e3 ? (n/1e3).toFixed(0)+'K' : String(n);
  const fmtUSD = n => n >= 1e6 ? '$'+(n/1e6).toFixed(1)+'M' : n >= 1e3 ? '$'+(n/1e3).toFixed(0)+'K' : '$'+n;

  const visitors   = latest ? fmt(latest.visitor_count)      : 'N/A';
  const revenue    = latest ? fmtUSD(latest.total_revenue)   : 'N/A';
  const conSpend   = latest ? fmtUSD(latest.conservation_spend) : 'N/A';
  const efficiency = (latest && latest.visitor_count > 0)
    ? '$'+(latest.conservation_spend / latest.visitor_count).toFixed(2) : 'N/A';
  const funding    = site.total_funding ? fmtUSD(Number(site.total_funding)) : '$0';
  const coords     = (site.latitude != null && site.longitude != null)
    ? `${site.latitude.toFixed(3)}°, ${site.longitude.toFixed(3)}°` : '—';

  /* Threats */
  const sevClass = s => ({ Low:'sev-low', Medium:'sev-medium', High:'sev-high', Critical:'sev-critical' }[s] || 'sev-medium');
  const threatsHTML = site.threats?.length
    ? site.threats.map(t => `
        <div class="threat-row">
          <div class="threat-sev-dot ${sevClass(t.severity)}"></div>
          <div>
            <div class="threat-cat">${t.category_name} <span style="font-weight:400;color:#9CA3AF">— ${t.severity}</span></div>
            <div class="threat-desc">${t.description}</div>
            ${t.resolved ? '<div class="threat-resolved">✓ Resolved</div>' : ''}
          </div>
        </div>`).join('')
    : '<p class="no-data">No active threats recorded.</p>';

  /* Zones */
  const ztClass = z => ({ 'Core':'zt-core', 'Buffer':'zt-buffer', 'Transition':'zt-transition' }[z] || 'zt-buffer');
  const zonesHTML = site.zones?.length
    ? site.zones.map(z => `
        <div class="zone-row">
          <div class="zone-label">
            ${z.zone_name}
            <span class="zone-type-tag ${ztClass(z.zone_type)}">${z.zone_type}</span>
          </div>
          <div class="zone-area">${Number(z.area_hectares).toLocaleString()} ha</div>
        </div>`).join('')
    : '<p class="no-data">No zone data.</p>';

  /* Conservation */
  const conservHTML = site.conservation ? `
    <div class="conservation-card">
      <div class="conservation-meta">
        <span>Assessed: <strong>${site.conservation.assessment_date?.slice(0,10)}</strong></span>
        <span>Next review: <strong>${site.conservation.next_review?.slice(0,10)}</strong></span>
      </div>
      ${site.conservation.notes}
    </div>` : '<p class="no-data">No conservation record.</p>';

  // Same fix: use background-image instead of <img> for CORS-safe display
  const heroBgStyle = imgUrl
    ? `style="background-image:url('${imgUrl}');background-size:cover;background-position:center top"`
    : '';

  panel.innerHTML = `
    <!-- Hero -->
    <div class="detail-hero" ${heroBgStyle}>
      <div class="detail-hero-overlay"></div>
      <div class="detail-hero-body">
        <div>
          <div class="detail-hero-title">${site.site_name}</div>
          <div class="detail-hero-sub">
            🌍 ${site.country_name}
            &nbsp;·&nbsp; ${site.category_name}
            &nbsp;·&nbsp; Inscribed ${site.inscription_year}
            &nbsp;·&nbsp; ${Number(site.area_hectares).toLocaleString()} ha
          </div>
        </div>
        <span class="detail-status-pill ${statusClass}">◎ ${riskLabel}</span>
      </div>
    </div>

    <!-- Description -->
    <p class="detail-desc">${site.outstanding_value}</p>

    <!-- Metrics -->
    <div class="detail-section-title">Key Metrics</div>
    <div class="metric-grid">
      <div class="metric-card">
        <div class="metric-label">Annual Visitors</div>
        <div class="metric-value">${visitors}</div>
        <div class="metric-unit">tourists / year</div>
      </div>
      <div class="metric-card">
        <div class="metric-label">Total Revenue</div>
        <div class="metric-value">${revenue}</div>
        <div class="metric-unit">USD</div>
      </div>
      <div class="metric-card">
        <div class="metric-label">Conservation Spend</div>
        <div class="metric-value">${conSpend}</div>
        <div class="metric-unit">USD</div>
      </div>
      <div class="metric-card">
        <div class="metric-label">Cost per Visitor</div>
        <div class="metric-value" style="font-size:1.3rem">${efficiency}</div>
        <div class="metric-unit">efficiency ratio</div>
      </div>
      <div class="metric-card">
        <div class="metric-label">Total Funding</div>
        <div class="metric-value" style="font-size:1.3rem">${funding}</div>
        <div class="metric-unit">allocated</div>
      </div>
      <div class="metric-card">
        <div class="metric-label">Endangered</div>
        <div class="metric-value" style="font-size:1.3rem;color:${site.is_endangered ? '#EF4444' : '#5C8A6E'}">
          ${site.is_endangered ? '⚠ Yes' : '✓ No'}
        </div>
        <div class="metric-unit">UNESCO list</div>
      </div>
    </div>

    <!-- Charts -->
    <div class="detail-section-title">Visitor Trend &amp; Budget</div>
    <div class="chart-row">
      <div class="chart-box">
        <div class="chart-box-title">Annual Visitors</div>
        <div class="chart-wrap"><canvas id="visitorChart"></canvas></div>
      </div>
      <div class="chart-box">
        <div class="chart-box-title">Revenue vs Conservation Spend</div>
        <div class="chart-wrap"><canvas id="budgetChart"></canvas></div>
      </div>
    </div>

    <!-- Conservation -->
    <div class="detail-section-title">Conservation Status</div>
    ${conservHTML}

    <!-- Threats -->
    <div class="detail-section-title">Threat Incidents</div>
    <div class="threats-list">${threatsHTML}</div>

    <!-- Zones -->
    ${site.zones?.length ? `
    <div class="detail-section-title">Site Zones</div>
    <div class="zones-list">${zonesHTML}</div>` : ''}

    <!-- Management -->
    <div class="detail-section-title">Management Details</div>
    <div class="mgmt-row">
      <span>Region: <strong>${site.region}</strong></span>
      <span>Category: <strong>${site.category_name}</strong></span>
      <span>Area: <strong>${Number(site.area_hectares).toLocaleString()} ha</strong></span>
      <span>Coordinates: <strong>${coords}</strong></span>
    </div>
  `;

  setTimeout(() => drawCharts(site), 80);
}

/* ── Charts ──────────────────────────────────────────────────── */
function drawCharts(site) {
  if (visitorChart) { visitorChart.destroy(); visitorChart = null; }
  if (budgetChart)  { budgetChart.destroy();  budgetChart  = null; }

  const visitors  = site.visitors || [];
  const baseOpts  = { responsive: true, maintainAspectRatio: false };
  const tickStyle = { font: { size: 10, family: 'Inter' }, color: '#9CA3AF' };
  const gridStyle = { color: 'rgba(0,0,0,0.04)' };

  const vc = document.getElementById('visitorChart');
  if (vc && visitors.length) {
    visitorChart = new Chart(vc, {
      type: 'line',
      data: {
        labels: visitors.map(v => v.report_year),
        datasets: [{
          data: visitors.map(v => v.visitor_count),
          borderColor: '#5C8A6E',
          backgroundColor: 'rgba(92,138,110,0.07)',
          fill: true, tension: 0.45,
          pointRadius: 3, pointBackgroundColor: '#5C8A6E',
          borderWidth: 2
        }]
      },
      options: {
        ...baseOpts,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { display: false }, ticks: tickStyle },
          y: {
            grid: gridStyle,
            ticks: {
              ...tickStyle,
              callback: v => v >= 1e6 ? (v/1e6).toFixed(1)+'M'
                           : v >= 1e3 ? (v/1e3).toFixed(0)+'K' : v
            }
          }
        }
      }
    });
  } else if (vc) {
    vc.closest('.chart-wrap').innerHTML =
      '<p class="no-data" style="padding-top:1rem">No visitor data yet.</p>';
  }

  const bc = document.getElementById('budgetChart');
  if (bc && visitors.length) {
    budgetChart = new Chart(bc, {
      type: 'bar',
      data: {
        labels: visitors.map(v => v.report_year),
        datasets: [
          {
            label: 'Revenue',
            data: visitors.map(v => v.total_revenue),
            backgroundColor: 'rgba(92,138,110,0.65)',
            borderRadius: 4
          },
          {
            label: 'Conservation',
            data: visitors.map(v => v.conservation_spend),
            backgroundColor: 'rgba(196,177,137,0.75)',
            borderRadius: 4
          }
        ]
      },
      options: {
        ...baseOpts,
        plugins: {
          legend: {
            display: true, position: 'top',
            labels: { boxWidth: 8, padding: 12, font: { size: 10 }, color: '#6B7280' }
          }
        },
        scales: {
          x: { grid: { display: false }, ticks: tickStyle },
          y: {
            grid: gridStyle,
            ticks: {
              ...tickStyle,
              callback: v => v >= 1e6 ? '$'+(v/1e6).toFixed(1)+'M'
                           : v >= 1e3 ? '$'+(v/1e3).toFixed(0)+'K' : '$'+v
            }
          }
        }
      }
    });
  } else if (bc) {
    bc.closest('.chart-wrap').innerHTML =
      '<p class="no-data" style="padding-top:1rem">No budget data yet.</p>';
  }
}