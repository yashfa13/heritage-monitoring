DROP DATABASE IF EXISTS heritage_monitoring;
CREATE DATABASE heritage_monitoring
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE heritage_monitoring;
CREATE TABLE Country (
    country_id      INT AUTO_INCREMENT PRIMARY KEY,
    country_name    VARCHAR(100)    NOT NULL UNIQUE,
    country_code    CHAR(3)         NOT NULL UNIQUE,   -- ISO 3166-1 alpha-3
    region          VARCHAR(80)     NOT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE HeritageCategory (
    category_id     INT AUTO_INCREMENT PRIMARY KEY,
    category_name   ENUM('Cultural','Natural','Mixed') NOT NULL,
    description     TEXT
);

CREATE TABLE HeritageSite (
    site_id             INT AUTO_INCREMENT PRIMARY KEY,
    site_name           VARCHAR(200)        NOT NULL,
    country_id          INT                 NOT NULL,
    category_id         INT                 NOT NULL,
    inscription_year    YEAR                NOT NULL,
    area_hectares       DECIMAL(12,2),
    latitude            DECIMAL(9,6),
    longitude           DECIMAL(9,6),
    outstanding_value   TEXT,                          
    is_endangered       TINYINT(1)          DEFAULT 0,
    created_at          TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_site_country  FOREIGN KEY (country_id)  REFERENCES Country(country_id),
    CONSTRAINT fk_site_cat      FOREIGN KEY (category_id) REFERENCES HeritageCategory(category_id)
);

CREATE TABLE SiteZone (
    zone_id         INT AUTO_INCREMENT PRIMARY KEY,
    site_id         INT             NOT NULL,
    zone_name       VARCHAR(100)    NOT NULL,
    zone_type       ENUM('Core','Buffer','Transition') NOT NULL,
    area_hectares   DECIMAL(10,2),
    CONSTRAINT fk_zone_site FOREIGN KEY (site_id) REFERENCES HeritageSite(site_id)
);

CREATE TABLE Department (
    dept_id         INT AUTO_INCREMENT PRIMARY KEY,
    dept_name       VARCHAR(100)    NOT NULL UNIQUE,
    budget_usd      DECIMAL(14,2),
    established     DATE
);

CREATE TABLE VisitorType (
    vtype_id        INT AUTO_INCREMENT PRIMARY KEY,
    type_name       VARCHAR(60)     NOT NULL UNIQUE,   
    entry_fee_usd   DECIMAL(6,2)    DEFAULT 0.00
);

CREATE TABLE Visitor (
    visitor_id      INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(120)    NOT NULL,
    nationality     VARCHAR(80),
    email           VARCHAR(120),
    vtype_id        INT             NOT NULL,
    CONSTRAINT fk_visitor_type FOREIGN KEY (vtype_id) REFERENCES VisitorType(vtype_id)
);

CREATE TABLE Visit (
    visit_id        INT AUTO_INCREMENT PRIMARY KEY,
    visitor_id      INT             NOT NULL,
    site_id         INT             NOT NULL,
    visit_date      DATE            NOT NULL,
    group_size      INT             DEFAULT 1,
    revenue_usd     DECIMAL(10,2),
    feedback_score  TINYINT         CHECK (feedback_score BETWEEN 1 AND 5),
    CONSTRAINT fk_visit_visitor FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id),
    CONSTRAINT fk_visit_site    FOREIGN KEY (site_id)    REFERENCES HeritageSite(site_id)
);

CREATE TABLE ConservationStatus (
    status_id       INT AUTO_INCREMENT PRIMARY KEY,
    status_label    VARCHAR(80)     NOT NULL UNIQUE,    
    risk_level      TINYINT         NOT NULL            
);

CREATE TABLE ConservationRecord (
    record_id       INT AUTO_INCREMENT PRIMARY KEY,
    site_id         INT             NOT NULL,
    status_id       INT             NOT NULL,
    assessment_date DATE            NOT NULL,
    notes           TEXT,
    next_review     DATE,
    CONSTRAINT fk_cr_site       FOREIGN KEY (site_id)      REFERENCES HeritageSite(site_id),
    CONSTRAINT fk_cr_status     FOREIGN KEY (status_id)    REFERENCES ConservationStatus(status_id)
);

CREATE TABLE ConservationProject (
    project_id      INT AUTO_INCREMENT PRIMARY KEY,
    site_id         INT             NOT NULL,
    project_name    VARCHAR(200)    NOT NULL,
    start_date      DATE,
    end_date        DATE,
    budget_usd      DECIMAL(14,2),
    status          ENUM('Planned','Ongoing','Completed','Suspended') DEFAULT 'Planned',
    CONSTRAINT fk_cp_site   FOREIGN KEY (site_id)       REFERENCES HeritageSite(site_id)
);

CREATE TABLE ThreatCategory (
    threat_cat_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(100)    NOT NULL UNIQUE,    -- e.g. Climate Change, Urbanisation
    description     TEXT
);

CREATE TABLE ThreatIncident (
    incident_id     INT AUTO_INCREMENT PRIMARY KEY,
    site_id         INT             NOT NULL,
    threat_cat_id   INT             NOT NULL,
    incident_date   DATE            NOT NULL,
    severity        ENUM('Low','Medium','High','Critical') NOT NULL,
    description     TEXT,
    resolved        TINYINT(1)      DEFAULT 0,
    resolved_date   DATE,
    CONSTRAINT fk_ti_site       FOREIGN KEY (site_id)       REFERENCES HeritageSite(site_id),
    CONSTRAINT fk_ti_cat        FOREIGN KEY (threat_cat_id) REFERENCES ThreatCategory(threat_cat_id)
);

CREATE TABLE FundingSource (
    fund_id         INT AUTO_INCREMENT PRIMARY KEY,
    source_name     VARCHAR(150)    NOT NULL UNIQUE,
    source_type     ENUM('Government','NGO','International','Private') NOT NULL,
    contact_email   VARCHAR(120)
);

CREATE TABLE FundingAllocation (
    allocation_id   INT AUTO_INCREMENT PRIMARY KEY,
    fund_id         INT             NOT NULL,
    site_id         INT             NOT NULL,
    project_id      INT,                              
    amount_usd      DECIMAL(14,2)   NOT NULL,
    allocation_date DATE            NOT NULL,
    fiscal_year     YEAR            NOT NULL,
    CONSTRAINT fk_fa_fund       FOREIGN KEY (fund_id)   REFERENCES FundingSource(fund_id),
    CONSTRAINT fk_fa_site       FOREIGN KEY (site_id)   REFERENCES HeritageSite(site_id),
    CONSTRAINT fk_fa_project    FOREIGN KEY (project_id) REFERENCES ConservationProject(project_id)
);

CREATE TABLE AnnualReport (
    report_id       INT AUTO_INCREMENT PRIMARY KEY,
    site_id         INT             NOT NULL,
    report_year     YEAR            NOT NULL,
    submission_date DATE,
    visitor_count   INT,
    total_revenue   DECIMAL(14,2),
    conservation_spend DECIMAL(14,2),
    summary         TEXT,
    CONSTRAINT fk_ar_site   FOREIGN KEY (site_id)       REFERENCES HeritageSite(site_id)
);

INSERT INTO Country (country_name, country_code, region) VALUES
('Italy',            'ITA', 'Europe & North America'),
('China',            'CHN', 'Asia & Pacific'),
('India',            'IND', 'Asia & Pacific'),
('Pakistan',         'PAK', 'Asia & Pacific'),
('Peru',             'PER', 'Latin America & Caribbean'),
('Egypt',            'EGY', 'Arab States'),
('Mexico',           'MEX', 'Latin America & Caribbean'),
('Japan',            'JPN', 'Asia & Pacific'),
('Brazil',           'BRA', 'Latin America & Caribbean'),
('Jordan',           'JOR', 'Arab States'),
('Kenya',            'KEN', 'Africa'),
('United Kingdom',   'GBR', 'Europe & North America'),
('Germany',          'GER', 'Europe & North America'),
('France',           'FR' , 'Europe & North America'),
('Spain',            'ES', 'Europe & North America');

INSERT INTO HeritageCategory (category_name, description) VALUES
('Cultural', 'Sites of cultural, historical, or architectural significance'),
('Natural',  'Sites of outstanding natural beauty or ecological importance'),
('Mixed',    'Sites satisfying both cultural and natural criteria');

INSERT INTO HeritageSite (site_id, site_name, country_id, category_id, inscription_year, area_hectares, latitude, longitude, outstanding_value, is_endangered) VALUES
 (1, 'Historic Centre of Rome',
   1, 1, 1980,  14000.00,  41.8902,  12.4922,
  'Exceptional Roman architecture, urban planning and monuments of world civilisation', 0),
 
( 2, 'Venice and its Lagoon',
   1, 1, 1987,  70176.00,  45.4408,  12.3155,
  'Extraordinary architectural ensemble built on water with unique urban form', 1),
 
( 3, 'Historic Centre of Florence',
   1, 1, 1982,  505.00,  43.7696,  11.2558,
  'Outstanding Renaissance art, architecture and urban planning of universal influence', 0),
 

( 4, 'Great Wall of China',
   2, 1, 1987, 621000.00,  40.4319, 116.5704,
  'Unique military architecture spanning 2,000 years of Chinese imperial history', 0),
 
( 5, 'Imperial Palaces of the Ming and Qing Dynasties',
   2, 1, 1987,    720.00,  39.9163, 116.3972,
  'Greatest collection of preserved ancient wooden structures in the world', 0),
 
( 6, 'Jiuzhaigou Valley Scenic Area',
   2, 2, 1992,  72000.00,  33.2600, 103.9170,
  'Exceptional scenic beauty with multi-level lakes, waterfalls and snow-capped peaks', 0),
 

( 7, 'Taj Mahal',
   3, 1, 1983,    242.00,  27.1751,  78.0421,
  'Jewel of Muslim art in India and universally admired masterpiece of world heritage', 0),
 
( 8, 'Group of Monuments at Hampi',
   3, 1, 1986,   4187.00,  15.3350,  76.4600,
  'Austere, grandiose ruins of the Vijayanagara Empire capital on the Tungabhadra River', 0),
 
( 9, 'Kaziranga National Park',
   3, 2, 1985,  42996.00,  26.5775,  93.1710,
  'Highest density of one-horned rhinoceroses; also harbours tigers, elephants and buffalo', 0),
 

(10, 'Mohenjo-daro',
   4, 1, 1980,  240.00,  27.3244,  68.1375,
  'Outstanding example of early human settlement and urban planning of the Indus civilisation', 0),
 
(11, 'Taxila',
   4, 1, 1980,  1076.00,  33.7738,  72.8433,
  'Important crossroads of trade routes linking Central Asia with the Indian subcontinent', 0),
 
(12, 'Fort and Shalamar Gardens in Lahore',
   4, 1, 1981,   159.00,  31.5921,  74.3087,
  'Outstanding examples of Mughal architecture blending Persian and South Asian traditions', 0),
 

(13, 'Historic Sanctuary of Machu Picchu',
   5, 3, 1983,  32592.00, -13.1631, -72.5450,
  'Inca citadel above the Sacred Valley showcasing pre-Columbian civilisation at its zenith', 0),
 
(14, 'Huascarán National Park',
   5, 2, 1985, 340000.00,  -9.1220, -77.6045,
  'Exceptional Andean landscapes with glaciers, lakes and biodiversity of global importance', 0),
 
(15, 'Chan Chan Archaeological Zone',
   5, 1, 1986,  2000.00,  -8.1000, -79.0681,
  'Largest pre-Columbian city in South America; capital of the Chimú Kingdom', 1),
 

(16, 'Memphis and its Necropolis – Pyramids of Giza',
   6, 1, 1979, 16000.00,  29.9792,  31.1342,
  'Funerary monuments representing the apogee of ancient Egyptian pyramid-building', 0),
 
(17, 'Ancient Thebes with its Necropolis',
   6, 1, 1979, 16000.00,  25.7189,  32.6561,
  'Valley of the Kings, Karnak Temple and Luxor Temple — supreme expression of pharaonic civilisation', 0),
 
(18, 'Abu Simbel to Philae – Nubian Monuments',
   6, 1, 1979,  3715.00,  22.3360,  31.6258,
  'Exceptional artistic achievement of Ramesses II; saved by international rescue campaign', 0),

(19, 'Pre-Hispanic City of Chichen-Itza',
   7, 1, 1988,   415.00,  20.6843, -88.5678,
  'Outstanding example of Mayan and Toltec architecture and astronomical knowledge', 0),
 
(20, 'Historic Centre of Mexico City and Xochimilco',
   7, 1, 1987,  1500.00,  19.4326, -99.1332,
  'Built on the ruins of the Aztec capital Tenochtitlan; exemplifies mestizo culture', 0),
 
(21, 'Sian Ka\'an Biosphere Reserve',
   7, 2, 1987, 528147.00,  19.5833, -87.6667,
  'Outstanding example of Yucatán coast ecosystems including coral reefs, mangroves and lagoons', 0),

(22, 'Historic Monuments of Ancient Nara',
   8, 1, 1998,   616.00,  34.6851, 135.8048,
  'Crystallisation of Japanese Buddhist art and architecture during the Nara period', 0),
 
(23, 'Hiroshima Peace Memorial (Genbaku Dome)',
   8, 1, 1996,     0.40,  34.3955, 132.4536,
  'Sole surviving structure near the hypocentre of the first atomic bomb; symbol of peace', 0),
 
(24, 'Shirakami-Sanchi',
   8, 2, 1993, 169700.00,  40.4500, 140.0500,
  'Last virgin remnants of the cool-temperate Siebold beech forests that once blanketed the region', 0),
 
(25, 'Central Amazon Conservation Complex',
   9, 2, 2000, 5813100.00,  -2.7500, -60.5000,
  'Largest protected area in the Amazon basin with extraordinary aquatic biodiversity', 0),
 
(26, 'Iguaçu National Park',
   9, 2, 1986, 185000.00, -25.6953, -54.4367,
  'Outstanding subtropical waterfalls shared with Argentina; exceptional biodiversity', 0),
 
(27, 'Historic Town of Ouro Preto',
   9, 1, 1980,  2699.00, -20.3856, -43.5036,
  'Exceptional example of 18th-century Portuguese colonial architecture and Baroque art', 0),
 
(28, 'Petra',
  10, 3, 1985,   264.00,  30.3285,  35.4444,
  'Nabataean caravan city blending Hellenistic and Eastern traditions with rock-cut architecture', 0),
 
(29, 'Quseir Amra',
  10, 1, 1985,    13.00,  31.8014,  36.5825,
  'Outstanding example of early Islamic art and architecture with remarkably preserved frescoes', 0),
 
(30, 'Wadi Rum Protected Area',
  10, 3, 2011, 74180.00,  29.5832,  35.4170,
  'Desert landscape shaped by erosion and human occupation; inscribed for natural and cultural values', 0),

(31, 'Mount Kenya National Park and Natural Forest',
  11, 3, 1997, 202334.00,  -0.1522,  37.3084,
  'Exceptional natural beauty with unique afro-alpine ecology and glaciers on the equator', 0),
 
(32, 'Lake Turkana National Parks',
  11, 2, 1997, 161485.00,   3.6000,  36.1000,
  'Largest alkaline lake in the world; crucial staging post for migratory birds', 1),
 
(33, 'Lamu Old Town',
  11, 1, 2001,    16.00,  -2.2694,  40.9014,
  'Oldest and best-preserved Swahili settlement in East Africa reflecting Omani, Indian and European influences', 0),

(34, 'Stonehenge, Avebury and Associated Sites',
  12, 1, 1986,  2600.00,  51.1789,  -1.8262,
  'Greatest prehistoric stone circles in the world; supreme expression of Neolithic and Bronze Age society', 0),
 
(35, 'Tower of London',
  12, 1, 1988,    48.00,  51.5081,  -0.0759,
  'White Tower built by William the Conqueror; symbol of Norman power in medieval England', 0),
 
(36, 'Giant\'s Causeway and Causeway Coast',
  12, 2, 1986,    70.00,  55.2408,  -6.5116,
  'Dramatic natural landscape of 40,000 interlocking basalt columns formed by volcanic activity', 0),
 

(37, 'Cologne Cathedral',
  13, 1, 1996,    11.60,  50.9413,   6.9583,
  'Outstanding example of High Gothic architecture; construction spanning over 600 years', 0),
 
(38, 'Palaces and Parks of Potsdam and Berlin',
  13, 1, 1990,   500.00,  52.4009,  13.0590,
  'Outstanding example of 18th–19th century European garden and palace architecture', 0),
 
(39, 'Messel Pit Fossil Site',
  13, 2, 1995,    42.00,  49.9333,   8.7667,
  'Richest site in the world for understanding the living environment of the Eocene epoch', 0),

(40, 'Mont-Saint-Michel and its Bay',
  14, 3, 1979, 11000.00,  48.6361,  -1.5115,
  'Abbey built on a tidal island; outstanding example of Norman Gothic architecture in a dramatic setting', 0),
 
(41, 'Versailles Palace and Park',
  14, 1, 1979, 83587.00,  48.8049,   2.1204,
  'Masterpiece of French 17th-century art combining palace, gardens and town planning of global influence', 0),
 
(42, 'Prehistoric Sites and Decorated Caves of the Vézère Valley',
  14, 1, 1979,   880.00,  44.9847,   1.0681,
  'Contains 147 prehistoric sites including Lascaux Cave with the finest examples of Palaeolithic art', 0),
 

(43, 'Alhambra, Generalife and Albayzín, Granada',
  15, 1, 1984,   142.00,  37.1760,  -3.5880,
  'Exceptional example of Nasrid palatial architecture and gardens blending Islamic and Christian cultures', 0),
 
(44, 'Gaudi Architectural Works in Catalonia',
  15, 1, 1984,     2.00,  41.4036,   2.1744,
  'Outstanding creative contribution to architecture featuring seven works by Antoni Gaudí', 0),
 
(45, 'Doñana National Park',
  15, 2, 1994, 507000.00,  36.9800,  -6.4700,
  'One of the most important wetland ecosystems in Europe; critical wintering area for migratory birds', 0);


INSERT INTO SiteZone (site_id, zone_name, zone_type, area_hectares) VALUES

( 1, 'Archaeological Core',          'Core',       400.00),
( 1, 'Historic Urban Buffer',        'Buffer',    1200.00),
( 1, 'Appian Way Transition',        'Transition',11600.00),
 

( 2, 'Canal Grande Historic Core',   'Core',      3000.00),
( 2, 'Lagoon Inner Buffer',          'Buffer',   24000.00),
( 2, 'Outer Lagoon Transition',      'Transition',43176.00),
 

( 3, 'Cathedral and Piazza Core',    'Core',       105.00),
( 3, 'Oltrarno Buffer Zone',         'Buffer',     280.00),
( 3, 'Arno Valley Transition',       'Transition', 120.00),

( 4, 'Ming Dynasty Wall Core',       'Core',     50000.00),
( 4, 'Northern Fortification Buffer','Buffer',  200000.00),
( 4, 'Cultural Landscape Transition','Transition',371000.00),

( 5, 'Palace Compound Core',         'Core',       360.00),
( 5, 'Imperial Garden Buffer',       'Buffer',     240.00),
( 5, 'Outer Court Transition',       'Transition', 120.00),
 

( 6, 'Fairy Lake Core',              'Core',     10800.00),
( 6, 'Valley Scenic Buffer',         'Buffer',   30000.00),
( 6, 'Mountain Transition Zone',     'Transition',31200.00),
 

( 7, 'Taj Mahal Plinth Core',        'Core',        40.00),
( 7, 'Mughal Garden Buffer',         'Buffer',     100.00),
( 7, 'Agra Riverside Transition',    'Transition', 102.00),
 

( 8, 'Royal Enclosure Core',         'Core',       530.00),
( 8, 'Tungabhadra Buffer',           'Buffer',    2000.00),
( 8, 'Agricultural Transition',      'Transition', 1657.00),

( 9, 'Rhino Sanctuary Core',         'Core',     17128.00),
( 9, 'Flood Plain Buffer',           'Buffer',   15000.00),
( 9, 'Community Transition Zone',    'Transition',10868.00),

(10, 'Citadel Mound Core',           'Core',        40.00),
(10, 'Lower Town Buffer',            'Buffer',     130.00),
(10, 'Archaeological Reserve',       'Transition',  70.00),

(11, 'Dharmarajika Stupa Core',      'Core',       170.00),
(11, 'Archaeological Zone Buffer',   'Buffer',     500.00),
(11, 'Margala Hills Transition',     'Transition', 406.00),
 

(12, 'Lahore Fort Core',             'Core',        20.00),
(12, 'Old City Buffer',              'Buffer',      90.00),
(12, 'Ravi River Transition',        'Transition',  49.00),

(13, 'Inca Citadel Core',            'Core',       530.00),
(13, 'Inca Trail Buffer',            'Buffer',    5200.00),
(13, 'Sacred Valley Transition',     'Transition',26862.00),

(14, 'Glacier Core Zone',            'Core',     60000.00),
(14, 'Andean Forest Buffer',         'Buffer',  150000.00),
(14, 'Highland Transition',          'Transition',130000.00),

(15, 'Ciudadela Royal Core',         'Core',       600.00),
(15, 'Urban Buffer Zone',            'Buffer',     900.00),
(15, 'Moche Valley Transition',      'Transition', 500.00),
 

(16, 'Pyramid Plateau Core',         'Core',      1800.00),
(16, 'Necropolis Buffer',            'Buffer',    6000.00),
(16, 'Desert Transition Zone',       'Transition', 8200.00),
 

(17, 'Valley of the Kings Core',     'Core',      1500.00),
(17, 'Karnak Temple Buffer',         'Buffer',    4500.00),
(17, 'West Bank Transition',         'Transition',10000.00),

(18, 'Abu Simbel Temple Core',       'Core',       200.00),
(18, 'Lake Nasser Buffer',           'Buffer',    2000.00),
(18, 'Desert Fringe Transition',     'Transition', 1515.00),
 

(19, 'El Castillo Core',             'Core',       100.00),
(19, 'Sacred Cenote Buffer',         'Buffer',     200.00),
(19, 'Jungle Transition Zone',       'Transition', 115.00),
 

(20, 'Zócalo and Cathedral Core',    'Core',       250.00),
(20, 'Xochimilco Buffer',            'Buffer',     700.00),
(20, 'Urban Fringe Transition',      'Transition', 550.00),
 

(21, 'Core Protected Zone',          'Core',    152000.00),
(21, 'Buffer Estuary Zone',          'Buffer',  200000.00),
(21, 'Coastal Transition Strip',     'Transition',176147.00),
 

(22, 'Tōdai-ji Temple Core',         'Core',       100.00),
(22, 'Nara Park Buffer',             'Buffer',     350.00),
(22, 'Yoshino Transition',           'Transition', 166.00),
 
(23, 'Genbaku Dome Core',            'Core',         0.10),
(23, 'Peace Memorial Park Buffer',   'Buffer',        0.19),
(23, 'Motoyasu River Transition',    'Transition',    0.11),
 

(24, 'Beech Forest Core',            'Core',     10139.00),
(24, 'Wildlife Habitat Buffer',      'Buffer',   80000.00),
(24, 'Mountain Transition Zone',     'Transition',79561.00),
 

(25, 'Jaú National Park Core',       'Core',   2272000.00),
(25, 'Várzea Floodplain Buffer',     'Buffer', 2000000.00),
(25, 'Terra Firme Transition',       'Transition',1541100.00),
 

(26, 'Waterfall Core Zone',          'Core',     18500.00),
(26, 'Atlantic Forest Buffer',       'Buffer',  100000.00),
(26, 'Riparian Transition Zone',     'Transition', 66500.00),
 
(27, 'Colonial Town Core',           'Core',       400.00),
(27, 'Heritage Buffer Zone',         'Buffer',    1200.00),
(27, 'Iron Quadrangle Transition',   'Transition', 1099.00),
 

(28, 'Petra Archaeological Core',    'Core',      2640.00),
(28, 'Beidha Neolithic Buffer',      'Buffer',    7000.00),
(28, 'Wadi Araba Transition',        'Transition',61760.00),
 

(29, 'Bathhouse Castle Core',        'Core',         6.00),
(29, 'Desert Plateau Buffer',        'Buffer',       5.00),
(29, 'Wadi Butm Transition',         'Transition',   2.00),
 

(30, 'Rum Village Core',             'Core',     12000.00),
(30, 'Sandstone Desert Buffer',      'Buffer',   30000.00),
(30, 'Hisma Plateau Transition',     'Transition',32180.00),
 

(31, 'Alpine Summit Core',           'Core',     71500.00),
(31, 'Montane Forest Buffer',        'Buffer',   83500.00),
(31, 'Community Conservancy Transition','Transition',47334.00),

(32, 'South Island Core',            'Core',     39000.00),
(32, 'Central Island Buffer',        'Buffer',    5100.00),
(32, 'Sibiloi Transition Zone',      'Transition',117385.00),
 

(33, 'Lamu Fort and Seafront Core',  'Core',         5.00),
(33, 'Old Town Buffer',              'Buffer',        8.00),
(33, 'Archipelago Transition',       'Transition',    3.00),
 

(34, 'Stonehenge Sarsen Core',       'Core',       250.00),
(34, 'Avebury Stone Circle Buffer',  'Buffer',    1100.00),
(34, 'Salisbury Plain Transition',   'Transition', 1250.00),

(35, 'White Tower Keep Core',        'Core',         5.00),
(35, 'Inner Ward Buffer',            'Buffer',       30.00),
(35, 'Thames Riverside Transition',  'Transition',   13.00),
 

(36, 'Basalt Column Core',           'Core',        10.00),
(36, 'Coastal Cliff Buffer',         'Buffer',      40.00),
(36, 'North Antrim Transition',      'Transition',  20.00),

(37, 'Cathedral Nave Core',          'Core',         1.60),
(37, 'Historic City Buffer',         'Buffer',       6.00),
(37, 'Rhine Corridor Transition',    'Transition',   4.00),
 

(38, 'Sanssouci Palace Core',        'Core',       290.00),
(38, 'Babelsberg Park Buffer',       'Buffer',     143.00),
(38, 'Glienicke Transition Zone',    'Transition',  67.00),
 
(39, 'Fossil Deposit Core',          'Core',        19.00),
(39, 'Geological Buffer Zone',       'Buffer',      17.00),
(39, 'Forest Transition Zone',       'Transition',   6.00),
 

(40, 'Island and Abbey Core',        'Core',        71.00),
(40, 'Bay Tidal Buffer',             'Buffer',    5000.00),
(40, 'Maritime Transition Zone',     'Transition', 5929.00),
 

(41, 'Grand Palace Core',            'Core',       800.00),
(41, 'Formal Garden Buffer',         'Buffer',    7000.00),
(41, 'Grand Canal Transition',       'Transition',75787.00),
 

(42, 'Lascaux Cave Core',            'Core',       100.00),
(42, 'Valley Archaeological Buffer', 'Buffer',     500.00),
(42, 'Dordogne Transition Zone',     'Transition', 280.00),
 

(43, 'Nasrid Palaces Core',          'Core',        35.00),
(43, 'Generalife Garden Buffer',     'Buffer',      70.00),
(43, 'Albayzín Transition',          'Transition',  37.00),
 

(44, 'Sagrada Família Core',         'Core',         0.50),
(44, 'Eixample Urban Buffer',        'Buffer',        1.00),
(44, 'Montjuïc Transition Zone',     'Transition',    0.50),

(45, 'Marismas Wetland Core',        'Core',    100000.00),
(45, 'Scrubland Buffer Zone',        'Buffer',  200000.00),
(45, 'Guadalquivir Transition',      'Transition',207000.00);


INSERT INTO Department (dept_name, budget_usd, established) VALUES
('Site Conservation',       2500000.00, '2000-01-15'),
('Visitor Services',         850000.00, '2000-01-15'),
('Research & Documentation', 600000.00, '2002-06-01'),
('Human Resources',          400000.00, '2000-01-15'),
('Finance & Funding',        750000.00, '2001-03-20'),
('Threat & Risk Management', 950000.00, '2005-07-10'),
('IT & Data Systems',        500000.00, '2010-09-01');


INSERT INTO VisitorType (type_name, entry_fee_usd) VALUES
('Individual Adult',  20.00),
('Individual Child',   8.00),
('Group Adult',       15.00),
('School Group',       5.00),
('Researcher',         0.00),
('VIP / Diplomat',     0.00);


INSERT INTO Visitor (visitor_id,full_name, nationality, email, vtype_id) VALUES
( 1, 'John Smith',            'American',    'j.smith@gmail.com',         1),
( 2, 'Aiko Sato',             'Japanese',    'a.sato@mail.jp',             1),
( 3, 'Priya Nair',            'Indian',      'p.nair@gmail.com',           1),
( 4, 'Marco Bianchi',         'Italian',     'm.bianchi@libero.it',        1),
( 5, 'Emma Wilson',           'British',     'e.wilson@outlook.co.uk',     1),
( 6, 'Carlos Ruiz',           'Mexican',     'c.ruiz@hotmail.mx',          1),
( 7, 'Keiko Hayashi',         'Japanese',    'k.hayashi@mail.jp',          1),
( 8, 'Sofia Ferreira',        'Brazilian',   's.ferreira@uol.com.br',      1),
( 9, 'Ahmed Khalil',          'Jordanian',   'a.khalil@yahoo.jo',          1),
(10, 'Grace Wanjiru',         'Kenyan',      'g.wanjiru@gmail.com',        1),
(11, 'Lena Müller',           'German',      'l.mueller@web.de',           1),
(12, 'Pierre Dubois',         'French',      'p.dubois@orange.fr',         1),
(13, 'Isabella Torres',       'Spanish',     'i.torres@correo.es',         1),
(14, 'Yusuf Al-Rashid',       'Saudi',       'y.alrashid@mail.sa',         1),
(15, 'Amara Osei',            'Ghanaian',    'a.osei@gmail.com',           1),

(16, 'Fatou Diop',            'Senegalese',  'f.diop@mail.sn',             3),
(17, 'Raj Mehta',             'Indian',      'r.mehta@gmail.com',          3),
(18, 'Hiroshi Tanaka',        'Japanese',    'h.tanaka@tour.jp',           3),
(19, 'Maria Gonzalez',        'Colombian',   'm.gonzalez@tour.co',         3),
(20, 'Oluwaseun Adeyemi',     'Nigerian',    'o.adeyemi@tourng.com',       3),

(21, 'Green Valley School',   'American',    'office@greenvalley.edu',     4),
(22, 'Al-Azhar Primary Cairo','Egyptian',    'trips@alazhar.edu.eg',       4),
(23, 'Delhi Public School',   'Indian',      'visits@dps.edu.in',          4),
(24, 'St. Paul\'s London',    'British',     'excursions@stpauls.sch.uk',  4),
(25, 'Colegio Nacional Lima', 'Peruvian',    'visitas@cnacional.edu.pe',   4),

(26, 'Dr. Li Wei',            'Chinese',     'l.wei@pekinguniv.cn',        5),
(27, 'Dr. Nadia Hassan',      'Egyptian',    'n.hassan@cairo.edu.eg',      5),
(28, 'Prof. James Okafor',    'Nigerian',    'j.okafor@unilag.edu.ng',     5),

(29, 'H.E. Amira Said',       'Egyptian',    'amira@embassy.eg',           6),
(30, 'H.E. Rajiv Menon',      'Indian',      'r.menon@indiamission.org',   6);


INSERT INTO Visit (visitor_id, site_id, visit_date, group_size, revenue_usd, feedback_score) VALUES
( 1,  1, '2023-03-15',  1,   20.00, 5),   -- John → Rome
( 2,  8, '2023-04-10',  1,   20.00, 5),   -- Aiko → Hampi
( 3,  7, '2023-04-22',  1,   20.00, 4),   -- Priya → Taj Mahal
( 4,  1, '2023-05-01',  1,   20.00, 5),   -- Marco → Rome
(16, 15, '2023-05-18', 12,  180.00, 4),   -- Fatou group → Chan Chan (endangered)
(21,  6, '2023-06-03', 30,  150.00, 4),   -- Green Valley School → Jiuzhaigou
(26,  2, '2023-06-20',  1,    0.00, 5),   -- Dr. Li Wei → Venice (researcher)
(29,  5, '2023-07-04',  1,    0.00, 5),   -- H.E. Amira → Forbidden City (VIP)
( 6,  6, '2023-07-19',  1,   20.00, 3),   -- Carlos → Jiuzhaigou
(10, 12, '2023-08-05',  1,   20.00, 5),   -- Grace → Lahore Fort
( 7,  8, '2023-08-22',  1,   20.00, 4),   -- Keiko → Hampi
(17,  7, '2023-09-09',  8,  120.00, 4),   -- Raj group → Taj Mahal
( 8,  4, '2023-09-28',  1,   20.00, 5),   -- Sofia → Great Wall
( 9, 10, '2023-10-12',  1,   20.00, 5),   -- Ahmed → Mohenjo-daro
( 5, 11, '2023-10-30',  1,   20.00, 4),   -- Emma → Taxila
( 1,  7, '2023-11-14',  1,   20.00, 5),   -- John → Taj Mahal (return visit)
( 2, 13, '2023-11-14',  1,   20.00, 4),   -- Aiko → Machu Picchu
( 3, 28, '2023-12-01',  1,   20.00, 5),   -- Priya → Petra
(16,  9, '2024-01-07', 14,  210.00, 5),   -- Fatou group → Kaziranga
( 6,  4, '2024-01-25',  1,   20.00, 5),   -- Carlos → Great Wall
( 5,  3, '2024-02-14',  1,   20.00, 5),   -- Emma → Florence
( 7,  2, '2024-02-28',  1,   20.00, 4),   -- Keiko → Venice (endangered; score reflects)
(19, 23, '2024-03-10', 10,  150.00, 5),   -- Maria group → Hiroshima Dome
( 9,  5, '2024-03-22',  1,   20.00, 4),   -- Ahmed → Forbidden City
(10, 15, '2024-04-05',  1,   20.00, 5),   -- Grace → Chan Chan
 
(11, 37, '2024-04-18',  1,   20.00, 5),   -- Lena → Cologne Cathedral
(12, 41, '2024-05-03',  1,   20.00, 5),   -- Pierre → Versailles
(13, 43, '2024-05-20',  1,   20.00, 5),   -- Isabella → Alhambra
(14, 16, '2024-06-08',  1,   20.00, 5),   -- Yusuf → Pyramids of Giza
(15, 33, '2024-06-25',  1,   20.00, 4),   -- Amara → Lamu Old Town
(18, 22, '2024-07-04', 15,  225.00, 5),   -- Hiroshi group → Ancient Nara
(20, 25, '2024-07-19', 18,  270.00, 4),   -- Oluwaseun group → Central Amazon
(22, 17, '2024-08-01', 25,  125.00, 5),   -- Al-Azhar School → Ancient Thebes
(23,  7, '2024-08-15', 35,  175.00, 5),   -- Delhi Public School → Taj Mahal
(24, 34, '2024-08-28', 28,  140.00, 5),   -- St. Paul's → Stonehenge
(25, 13, '2024-09-10', 40,  200.00, 5),   -- Colegio Lima → Machu Picchu
(27, 18, '2024-09-24',  1,    0.00, 5),   -- Dr. Hassan → Abu Simbel (researcher)
(28, 31, '2024-10-07',  1,    0.00, 4),   -- Prof. Okafor → Mount Kenya (researcher)
(30, 40, '2024-10-21',  1,    0.00, 5),   -- H.E. Menon → Mont-Saint-Michel (VIP)
( 4, 44, '2024-11-05',  1,   20.00, 4),   -- Marco → Gaudí Works
( 8, 27, '2024-11-18',  1,   20.00, 5),   -- Sofia → Ouro Preto
(17, 26, '2024-12-03',  9,  135.00, 5),   -- Raj group → Iguaçu
(11, 38, '2024-12-20',  1,   20.00, 5),   -- Lena → Potsdam Palaces

( 1, 34, '2025-01-09',  1,   20.00, 5),   -- John → Stonehenge
(12, 42, '2025-01-23',  1,   20.00, 5),   -- Pierre → Vézère Caves
(13, 45, '2025-02-06',  1,   20.00, 4),   -- Isabella → Doñana
(14, 29, '2025-02-19',  1,   20.00, 5),   -- Yusuf → Quseir Amra
(15, 32, '2025-03-04',  1,   20.00, 3),   -- Amara → Lake Turkana (endangered; lower score)
(18, 19, '2025-03-18', 20,  300.00, 5),   -- Hiroshi group → Chichen-Itza
(20, 14, '2025-04-01', 16,  240.00, 4),   -- Oluwaseun group → Huascarán
(26,  4, '2025-04-15',  1,    0.00, 5),   -- Dr. Li Wei → Great Wall (researcher)
(27, 39, '2025-04-29',  1,    0.00, 5),   -- Dr. Hassan → Messel Pit (researcher)
(29, 43, '2025-05-13',  1,    0.00, 5),   -- H.E. Amira → Alhambra (VIP)
( 6, 30, '2025-05-27',  1,   20.00, 5),   -- Carlos → Wadi Rum
( 9, 28, '2025-06-10',  1,   20.00, 5),   -- Ahmed → Petra
( 3, 12, '2025-06-24',  1,   20.00, 4),   -- Priya → Lahore Fort
( 5, 35, '2025-07-08',  1,   20.00, 5),   -- Emma → Tower of London
( 7, 24, '2025-07-22',  1,   20.00, 5),   -- Keiko → Shirakami-Sanchi
(10, 31, '2025-08-05',  1,   20.00, 5),   -- Grace → Mount Kenya
( 2, 20, '2025-08-19',  1,   20.00, 4),   -- Aiko → Mexico City Historic Centre
( 8, 13, '2025-09-02',  1,   20.00, 5),   -- Sofia → Machu Picchu
(21, 36, '2025-09-16', 33,  165.00, 5),   -- Green Valley School → Giant's Causeway
( 4, 40, '2025-09-30',  1,   20.00, 5);   -- Marco → Mont-Saint-Michel


INSERT INTO ConservationStatus (status_label, risk_level) VALUES
('Excellent', 1),
('Good',      2),
('Fair',      3),
('Critical',  4);


INSERT INTO ConservationRecord (site_id, status_id, assessment_date, notes, next_review) VALUES
-- ── ITALY ────────────────────────────────────────────────────
( 1, 1, '2023-01-10',
  'Post-restoration structural audit passed; visitor access restored to 90% of galleries',
  '2024-01-10'),
( 2, 4, '2023-02-15',
  'MOSE flood barrier only partially operational; 2019–2023 flooding events damaged 50+ ground-floor properties',
  '2023-08-15'),
( 3, 2, '2023-03-05',
  'Renaissance facades in good condition; Arno flood-risk mitigation programme active',
  '2024-03-05'),

-- ── CHINA ────────────────────────────────────────────────────
( 4, 2, '2023-03-20',
  'Ming-dynasty rammed-earth sections show ongoing wind and rain erosion; 2023 repair budget approved',
  '2024-03-20'),
( 5, 1, '2023-04-08',
  'Timber frame structures within tolerance; annual termite survey clear',
  '2024-04-08'),
( 6, 2, '2023-04-25',
  'Calcified lake colours stable; entrance quota of 12,000 visitors/day enforced since 2021',
  '2024-04-25'),

-- ── INDIA ────────────────────────────────────────────────────
( 7, 2, '2023-05-10',
  'Makrana marble yellowing index at 3.1 (threshold 4.0); SO₂ scrubbers operational around 10-km TTZ',
  '2023-11-10'),
( 8, 2, '2023-05-28',
  'Enclosure walls stable; Tungabhadra reservoir siltation monitored upstream',
  '2024-05-28'),
( 9, 1, '2023-06-12',
  'One-horned rhino population reached 2,613 in 2022 census — highest since records began',
  '2024-06-12'),

-- ── PAKISTAN ─────────────────────────────────────────────────
(10, 3, '2023-06-28',
  'Brick decay accelerating due to monsoon flooding; UNESCO emergency conservation mission dispatched 2023',
  '2024-01-28'),
(11, 2, '2023-07-15',
  'Buddhist stupa excavation zone stable; road construction moratorium within 500m maintained',
  '2024-07-15'),
(12, 2, '2023-07-30',
  'Lahore Fort sheesh mahal mirror-work restoration 65% complete; Shalamar canal water supply restored',
  '2024-01-30'),

-- ── PERU ─────────────────────────────────────────────────────
(13, 2, '2023-08-14',
  'Inca agricultural terraces stable; Inca Trail capped at 500 trekkers/day since 2001 — compliance high',
  '2024-02-14'),
(14, 2, '2023-08-30',
  'Pastoruri Glacier has retreated 600m since 1995; annual monitoring transects reestablished',
  '2024-08-30'),
(15, 4, '2023-09-16',
  'Adobe citadel walls critically eroded by El Niño rains; drainage channels breached in 2023',
  '2023-12-16'),

-- ── EGYPT ────────────────────────────────────────────────────
(16, 2, '2023-09-30',
  'Pyramid limestone casing stable; Sphinx restoration Phase 4 complete; underground water table monitored',
  '2024-09-30'),
(17, 2, '2023-10-14',
  'Karnak hypostyle hall masonry sound; Luxor Temple lit project reducing heat-induced spalling',
  '2024-04-14'),
(18, 1, '2023-10-28',
  'Abu Simbel facade stable 50 years after UNESCO relocation; visitor walkways resurfaced 2023',
  '2024-10-28'),

-- ── MEXICO ───────────────────────────────────────────────────
(19, 1, '2023-11-12',
  'El Castillo pyramid structurally sound; closed to climbing since 2006 — erosion rate near zero',
  '2024-11-12'),
(20, 3, '2023-11-26',
  'Xochimilco chinampas suffering from invasive species and water pollution; emergency action plan 2023',
  '2024-05-26'),
(21, 1, '2023-12-10',
  'Coral reef health at 72% coverage; no new bleaching events recorded in 2023',
  '2024-06-10'),

-- ── JAPAN ────────────────────────────────────────────────────
(22, 1, '2023-12-24',
  'Tōdai-ji Great Buddha Hall passed 2023 structural survey; deer population management ongoing',
  '2024-12-24'),
(23, 1, '2024-01-08',
  'Genbaku Dome skeleton structurally reinforced 2022; humidity sensors within tolerance',
  '2025-01-08'),
(24, 1, '2024-01-22',
  'Beech forest canopy 97% intact; brown bear and golden eagle populations stable in 2023 surveys',
  '2025-01-22'),

-- ── BRAZIL ───────────────────────────────────────────────────
(25, 2, '2024-02-05',
  'INPE 2023 satellite data: deforestation pressure in buffer zone reduced 18% vs 2022 baseline',
  '2025-02-05'),
(26, 1, '2024-02-19',
  'Waterfall system unaffected by 2023 floods upstream; jaguar camera-trap survey positive',
  '2025-02-19'),
(27, 2, '2024-03-04',
  'Colonial baroque churches: 4 of 13 have active water-ingress repairs; ironwork facades sound',
  '2025-03-04'),

-- ── JORDAN ───────────────────────────────────────────────────
(28, 2, '2024-03-18',
  'Nabataean rock-cut tombs stable; flash flood diversion channels functional after 2022 upgrade',
  '2025-03-18'),
(29, 1, '2024-04-01',
  'Qusayr Amra frescoes: colour indices stable after 2021 climate-control installation',
  '2025-04-01'),
(30, 1, '2024-04-15',
  'Desert landscape unchanged; Bedouin heritage tourism integrated into management plan 2023',
  '2025-04-15'),

-- ── KENYA ────────────────────────────────────────────────────
(31, 1, '2024-04-29',
  'Upper montane forest buffer cleared of invasive Clidemia hirta; glaciers retreated 40% since 1900 — documented',
  '2025-04-29'),
(32, 3, '2024-05-13',
  'Lake levels dropped 10m since 1975 due to upstream irrigation; flamingo breeding colony declined 30%',
  '2024-11-13'),
(33, 2, '2024-05-27',
  'Lamu stone-town buildings: 12% require urgent masonry repair; sea-water intrusion monitored',
  '2025-05-27'),

-- ── UNITED KINGDOM ───────────────────────────────────────────
(34, 1, '2024-06-10',
  'Sarsen and bluestone settings structurally stable; visitor volume controlled at 5,000/day on solstice',
  '2025-06-10'),
(35, 1, '2024-06-24',
  'Tower masonry inspection 2023: all curtain walls within safe parameters; ravens colony maintained',
  '2025-06-24'),
(36, 1, '2024-07-08',
  'Basalt columns: no significant fracture propagation detected; coastal erosion rate 2cm/year — normal',
  '2025-07-08'),

-- ── GERMANY ──────────────────────────────────────────────────
(37, 1, '2024-07-22',
  'Gothic tracery and stained glass passed 2023 annual inspection; soot-cleaning campaign on south transept complete',
  '2025-07-22'),
(38, 2, '2024-08-05',
  'Sanssouci terraces repaired; Babelsberg park boundary encroachment by residential development under legal review',
  '2025-08-05'),
(39, 1, '2024-08-19',
  'Fossil-bearing strata access controlled; visitor numbers capped at 350/day to prevent vibration damage',
  '2025-08-19'),

-- ── FRANCE ───────────────────────────────────────────────────
(40, 1, '2024-09-02',
  'Abbey roofline repairs completed 2022; tidal sediment management plan reviewed and approved 2023',
  '2025-09-02'),
(41, 2, '2024-09-16',
  'Grand Canal leak repaired; Hall of Mirrors chandelier restoration 70% complete; visitor footfall at 7.7M in 2023',
  '2025-09-16'),
(42, 2, '2024-09-30',
  'Lascaux IV facsimile operational; original cave sealed — CO₂ and humidity within conservation thresholds',
  '2025-09-30'),

-- ── SPAIN ────────────────────────────────────────────────────
(43, 1, '2024-10-14',
  'Nasrid plasterwork stable; Generalife irrigation channels restored 2022; visitor cap 6,600/day enforced',
  '2025-10-14'),
(44, 2, '2024-10-28',
  'Sagrada Família construction within conservation guidelines; Gaudí trencadís mosaics stable on Casa Batlló',
  '2025-10-28'),
(45, 1, '2024-11-11',
  '2023 flamingo census: 120,000 birds — population stable; lynx reintroduction programme at 1,100 individuals',
  '2025-11-11');



INSERT INTO ConservationProject (site_id, project_name, start_date, end_date, budget_usd, status) VALUES

( 2, 'Venice MOSE Flood Barrier Completion & Lagoon Monitoring',    '2020-01-01','2025-12-31',  5600000000.00, 'Ongoing'),
( 1, 'Colosseum Structural Reinforcement Phase III',                 '2022-06-01','2024-12-31',   3200000.00,   'Ongoing'),
( 3, 'Florence Historic Centre Digital Twins Mapping',              '2023-03-01','2026-06-30',    480000.00,   'Ongoing'),


( 4, 'Great Wall Rammed-Earth Section Stabilisation — Gansu',       '2021-05-01','2025-09-30',  2500000.00,   'Ongoing'),
( 6, 'Jiuzhaigou Post-Earthquake Ecosystem Restoration',            '2018-08-01','2024-12-31',  8200000.00,   'Ongoing'),

( 7, 'Taj Mahal Taj Trapezium Zone Air-Quality Programme',          '2019-01-01','2026-12-31',   620000.00,   'Ongoing'),
( 9, 'Kaziranga Rhino Corridor Restoration',                        '2022-04-01','2027-03-31',  1400000.00,   'Ongoing'),

(10, 'Mohenjo-daro Brick Decay Emergency Stabilisation',            '2023-07-01','2026-06-30',  3800000.00,   'Ongoing'),
(12, 'Lahore Sheesh Mahal Mirror-Work Restoration',                 '2021-11-01','2024-10-31',   750000.00,   'Ongoing'),

(13, 'Machu Picchu Carrying-Capacity & Visitor-Flow Study',         '2022-01-01','2024-12-31',   310000.00,   'Completed'),
(15, 'Chan Chan Adobe Wall Emergency Drainage System',              '2023-10-01','2026-09-30',  4200000.00,   'Ongoing'),

(16, 'Giza Plateau Sphinx Groundwater Mitigation Phase 4',          '2021-06-01','2025-05-31',  1750000.00,   'Ongoing'),
(17, 'Karnak Hypostyle Hall Laser-Cleaning Restoration',            '2023-02-01','2025-01-31',   900000.00,   'Ongoing'),

(19, 'Chichen-Itza Underground Cenote Mapping & Monitoring',        '2022-09-01','2025-08-31',   560000.00,   'Ongoing'),
(20, 'Xochimilco Chinampas Invasive Species & Pollution Remediation','2023-06-01','2028-05-31', 2300000.00,   'Ongoing'),

(23, 'Hiroshima Genbaku Dome Humidity-Control Upgrade',             '2022-04-01','2024-03-31',   280000.00,   'Completed'),
(24, 'Shirakami Beech Forest Invasive Species Management',          '2021-10-01','2025-09-30',   670000.00,   'Ongoing'),

(25, 'Amazon Conservation Complex Deforestation Early-Warning System','2022-01-01','2026-12-31', 3100000.00,  'Ongoing'),
(26, 'Iguaçu Jaguar Corridor Connectivity Restoration',             '2023-03-01','2027-02-28',  1850000.00,   'Ongoing'),

(28, 'Petra Flash-Flood Diversion Channel Phase 2',                 '2022-07-01','2025-06-30',  2100000.00,   'Ongoing'),
(29, 'Quseir Amra Fresco Climate-Control Installation',             '2020-06-01','2021-12-31',   380000.00,   'Completed'),

(31, 'Mount Kenya Invasive Plant Removal — Upper Forest Belt',      '2022-01-01','2025-12-31',   510000.00,   'Ongoing'),
(32, 'Lake Turkana Water-Level Monitoring & Flamingo Habitat Plan', '2023-05-01','2028-04-30',  1600000.00,   'Ongoing'),

(34, 'Stonehenge Landscape Restoration — A303 Tunnel Scheme',       '2023-11-01','2028-10-31', 2100000000.00,'Ongoing'),
(35, 'Tower of London Curtain Wall Masonry Repointing',             '2022-09-01','2024-08-31',   420000.00,   'Completed'),


(37, 'Cologne Cathedral South-Transept Soot-Removal Campaign',      '2022-05-01','2024-04-30',   330000.00,   'Completed'),
(38, 'Potsdam Babelsberg Park Boundary Encroachment Legal Review',  '2023-01-01','2025-12-31',   120000.00,   'Planned'),


(40, 'Mont-Saint-Michel Tidal Sediment Management Plan Review',     '2022-03-01','2024-02-28',   290000.00,   'Completed'),
(42, 'Lascaux Cave Micro-Climate Stabilisation System Upgrade',     '2023-09-01','2025-08-31',   510000.00,   'Ongoing'),


(43, 'Alhambra Nasrid Plasterwork Conservation — East Wing',        '2022-06-01','2025-05-31',   870000.00,   'Ongoing');


INSERT INTO ThreatCategory (category_name, description) VALUES
('Climate Change',      'Rising temperatures, sea-level rise, extreme weather events'),
('Urbanisation',        'Expansion of urban areas and infrastructure near sites'),
('Tourism Pressure',    'Excessive visitor numbers causing physical wear'),
('Illegal Trafficking', 'Looting, theft and illegal trade of cultural artefacts'),
('Pollution',           'Air, water or soil contamination affecting the site'),
('Natural Disaster',    'Earthquakes, floods, landslides, volcanic activity'),
('Deforestation',       'Removal of protective forest cover in natural sites'),
('Poaching',            'Illegal hunting within natural and mixed heritage sites');


INSERT INTO ThreatIncident (site_id, threat_cat_id, incident_date, severity, description, resolved, resolved_date) VALUES
-- Site 1 • Rome
( 1, 3, '2023-05-22', 'Low',
  'Graffiti tags found on outer perimeter wall near Arch of Constantine; cleaned within 10 days',
  1, '2023-06-01'),

-- Site 2 • Venice
( 2, 1, '2023-11-05', 'Critical',
  'Acqua alta of 187cm recorded — second highest ever; 70% of city flooded; MOSE gates deployed late',
  0, NULL),

-- Site 3 • Florence
( 3, 5, '2023-03-12', 'Medium',
  'Acid rain deposits (pH 4.2) detected on Duomo south facade; emergency wax consolidant applied',
  0, NULL),

-- Site 4 • Great Wall
( 4, 1, '2023-07-30', 'High',
  'Record rainfall in Hebei caused 3 watchtower collapses on wild wall sections near Zhuangdaokou',
  0, NULL),

-- Site 5 • Forbidden City
( 5, 3, '2023-10-03', 'Medium',
  'National Day Golden Week: 80,000 visitors/day exceeded 80,000 daily cap — queuing disorder reported',
  1, '2023-10-09'),

-- Site 6 • Jiuzhaigou
( 6, 6, '2023-08-20', 'Medium',
  'Ms 4.8 aftershock (post-2017 earthquake sequence) caused minor rock-fall on tourist path 3',
  1, '2023-09-15'),

-- Site 7 • Taj Mahal
( 7, 5, '2023-02-28', 'Medium',
  'SO₂ and particulate levels breached TTZ thresholds during Holi festival; 2-day vehicle ban enforced',
  1, '2023-03-03'),

-- Site 8 • Hampi
( 8, 2, '2023-05-05', 'Medium',
  'Proposed flyover bridge 400m from Virupaksha Temple; archaeological objection filed with National Highway Authority',
  0, NULL),

-- Site 9 • Kaziranga
( 9, 8, '2023-04-01', 'High',
  'Three one-horned rhinos poached in southern buffer; inter-agency task force deployed',
  1, '2023-06-10'),

-- Site 10 • Mohenjo-daro
(10, 1, '2023-08-30', 'Critical',
  '2023 Indus flood inundated 30% of site; mud deposits of 15–20cm on excavated structures',
  0, NULL),

-- Site 11 • Taxila
(11, 2, '2023-06-14', 'Medium',
  'Illegal brick-kiln operating 800m from Dharmarajika Stupa; smoke damage to plaster; kiln ordered closed',
  1, '2023-07-20'),

-- Site 12 • Lahore Fort
(12, 3, '2023-08-15', 'Medium',
  'Basant kite-festival crowds caused ground compaction and minor erosion to Hazuri Bagh lawns',
  1, '2023-08-20'),

-- Site 13 • Machu Picchu
(13, 3, '2023-07-04', 'High',
  'Post-pandemic rebound: 4,200 visitors recorded in a single day — 40% above 3,000 daily permit limit',
  1, '2023-07-10'),

-- Site 14 • Huascarán
(14, 1, '2023-09-15', 'High',
  'Pastoruri Glacier retreated 12m in 2023 monitoring season; pro-glacial lake outburst flood risk elevated',
  0, NULL),

-- Site 15 • Chan Chan
(15, 6, '2023-03-15', 'Critical',
  'Cyclone Yaku brought 340mm rain in 48h; three main ciudadela entrance walls partially collapsed',
  0, NULL),

-- Site 16 • Pyramids of Giza
(16, 5, '2023-06-08', 'High',
  'Unprecedented sandstorm (khamaseen) with 60m/s gusts abraded exposed limestone casing over 2 km²',
  0, NULL),

-- Site 17 • Ancient Thebes
(17, 2, '2023-09-22', 'Medium',
  'Illegal souvenir stall encampment inside buffer zone near Valley of the Kings; 14 stalls removed',
  1, '2023-10-05'),

-- Site 18 • Abu Simbel
(18, 1, '2023-11-18', 'Medium',
  'Lake Nasser water level 7m below 1970 design level; exposed foundations of relocated temple inspected',
  0, NULL),

-- Site 19 • Chichen-Itza
(19, 3, '2023-07-29', 'Medium',
  'Visitor numbers 45% above carrying capacity during summer peak; ticket system overhaul announced',
  1, '2023-08-10'),

-- Site 20 • Mexico City Historic Centre
(20, 5, '2023-04-18', 'High',
  'Xochimilco water quality: coliform bacteria 3× WHO limit from untreated wastewater discharge',
  0, NULL),

-- Site 21 • Sian Ka'an
(21, 7, '2023-06-01', 'Medium',
  'Illegal logging of 12 ha in transition zone detected via Sentinel-2 satellite; ejido concession revoked',
  1, '2023-09-12'),

-- Site 22 • Ancient Nara
(22, 3, '2023-10-28', 'Medium',
  'Autumn leaf-viewing season brought 320,000 visitors over two weekends; footpath erosion on Kasugayama hill',
  1, '2023-12-01'),

-- Site 23 • Hiroshima Dome
(23, 5, '2024-01-15', 'Low',
  'Micro-algae bloom on western concrete surface; cleaned with biocide in line with conservation protocol',
  1, '2024-01-30'),

-- Site 24 • Shirakami-Sanchi
(24, 7, '2023-09-01', 'Medium',
  'Unauthorised clear-cutting of 4 ha in buffer zone detected; forestry company fined ¥18M',
  1, '2023-11-20'),

-- Site 25 • Central Amazon
(25, 7, '2023-07-22', 'High',
  'INPE alert: 930 ha of buffer zone cleared by land-grabbers in dry season; federal police deployed',
  0, NULL),

-- Site 26 • Iguaçu
(26, 6, '2023-05-18', 'Medium',
  'Upstream floods raised Iguaçu River 14m above normal; visitor walkways submerged for 6 days',
  1, '2023-05-28'),

-- Site 27 • Ouro Preto
(27, 6, '2023-01-20', 'High',
  'Extreme rainfall caused hillside landslide blocking Rua Direita; 3 colonial-era buildings cracked',
  1, '2023-04-15'),

-- Site 28 • Petra
(28, 6, '2023-11-14', 'Critical',
  'Flash flood through Siq canyon: 1.2m water depth, tourist evacuation; channel wall damaged 80m',
  0, NULL),

-- Site 29 • Quseir Amra
(29, 5, '2024-02-20', 'Low',
  'Salt-crystallisation spalling on outer bath-house wall; consolidant injection treatment planned',
  0, NULL),

-- Site 30 • Wadi Rum
(30, 2, '2023-12-08', 'Low',
  'Illegal campsite of 9 tents inside core zone; occupants removed; site litter-cleared',
  1, '2023-12-12'),

-- Site 31 • Mount Kenya
(31, 7, '2023-08-05', 'Medium',
  'Invasive Clidemia hirta expanding into upper forest belt; removal programme underfunded by 40%',
  0, NULL),

-- Site 32 • Lake Turkana
(32, 1, '2023-10-10', 'High',
  'Lake level dropped 0.8m in 2023 — fastest single-year decline since 2010; Ethiopian dam cited',
  0, NULL),

-- Site 33 • Lamu Old Town
(33, 1, '2024-03-05', 'Medium',
  'Tidal flooding of 28 ground-floor heritage buildings during March spring tide; sand-bagging deployed',
  1, '2024-03-15'),

-- Site 34 • Stonehenge
(34, 6, '2024-01-18', 'Low',
  'Ground subsidence of 22mm detected 180m from outer stone circle by InSAR satellite monitoring',
  0, NULL),

-- Site 35 • Tower of London
(35, 3, '2023-08-12', 'Medium',
  'Summer peak: 6,200 visitors/day exceeded recommended cap; crowd modelling review commissioned',
  1, '2023-09-01'),

-- Site 36 • Giant's Causeway
(36, 1, '2023-12-27', 'Medium',
  'Storm Gerrit produced 10m wave run-up; coastal path undermined by 3m at Shepherds Steps',
  0, NULL),

-- Site 37 • Cologne Cathedral
(37, 5, '2023-05-30', 'Low',
  'Black-crust buildup on northern portal sculptures — result of residual diesel soot; cleaning programmed',
  1, '2023-11-30'),

-- Site 38 • Potsdam Palaces
(38, 2, '2023-09-18', 'Medium',
  'Planning application for 240-unit residential block 300m from Babelsberg park boundary; heritage objection lodged',
  0, NULL),

-- Site 39 • Messel Pit
(39, 2, '2024-02-10', 'Low',
  'Adjacent industrial noise (quarry blasting 1.1 km away) measured at 68 dB; vibrational study commissioned',
  0, NULL),

-- Site 40 • Mont-Saint-Michel
(40, 1, '2023-02-06', 'Medium',
  'Storm Ciaran: 230 km/h gusts damaged weathervane and dislodged 4 roof slates on abbey north wing',
  1, '2023-04-20'),

-- Site 41 • Versailles
(41, 3, '2023-08-19', 'Medium',
  'Saturday peak footfall 35,000 — Hall of Mirrors humidity rose to 72% RH, above 60% conservation limit',
  1, '2023-09-01'),

-- Site 42 • Vézère Caves
(42, 5, '2023-07-08', 'High',
  'CO₂ spike to 4,200 ppm in Lascaux original cave due to anomalous summer heat — fungal watch activated',
  0, NULL),

-- Site 43 • Alhambra
(43, 3, '2023-10-12', 'Medium',
  'October long weekend: ticket touts operating outside Puerta de la Justicia; 12 arrested, new ticket system piloted',
  1, '2023-10-20'),

-- Site 44 • Gaudí Works
(44, 2, '2024-01-25', 'Medium',
  'Construction vibration from Sagrada Família crane operations detected at 4.2mm/s at Casa Milà — within limit but logged',
  0, NULL),

-- Site 45 • Doñana
(45, 1, '2023-06-15', 'Critical',
  'Unprecedented summer drought: Doñana lagoons dried 80% — worst since records began; lynx and flamingo emergency measures',
  0, NULL);


INSERT INTO FundingSource (source_name, source_type, contact_email) VALUES
('UNESCO World Heritage Fund',             'International', 'whf@unesco.org'),
('European Heritage Alliance',             'NGO',           'info@eur-heritage.eu'),
('World Bank Cultural Heritage Program',   'International', 'chp@worldbank.org'),
('Italian Ministry of Culture',            'Government',    'mibact@cultura.gov.it'),
('Japan Society for Heritage Preservation','NGO',           'jsh@bunka.go.jp'),
('Global Conservation Trust',             'Private',       'grants@gct.org'),
('USAID Cultural Property Protection',    'Government',    'cpp@usaid.gov'),
('Aga Khan Trust for Culture',            'NGO',           'info@aktc.org'),
('European Investment Bank',              'International', 'info@eib.europa.eu'),
('Government of Pakistan — NFCH',         'Government',    'nfch@culture.gov.pk'),
('Getty Conservation Institute',          'NGO',           'gciweb@getty.edu'),
('French Ministry of Culture',            'Government',    'info@culture.gouv.fr');


INSERT INTO FundingAllocation (fund_id, site_id, project_id, amount_usd, allocation_date, fiscal_year) VALUES
-- Rome Colosseum project (project 2)
(1,  1,  2,  1200000.00, '2022-07-01', 2022),
(4,  1,  2,   800000.00, '2022-07-15', 2022),
(6,  1,  2,   500000.00, '2023-01-10', 2023),
-- Venice MOSE project (project 1)
(9,  2,  1, 3000000000.00,'2020-06-01', 2020),
(1,  2,  1,  2400000.00, '2023-04-01', 2023),
(2,  2,  1,  1200000.00, '2023-05-01', 2023),
-- Florence digital twins (project 3)
(1,  3,  3,   240000.00, '2023-03-10', 2023),
(2,  3,  3,   140000.00, '2023-03-15', 2023),
-- Great Wall (project 4)
(1,  4,  4,  1500000.00, '2021-06-01', 2021),
(3,  4,  4,   750000.00, '2022-01-05', 2022),
-- Jiuzhaigou (project 5)
(1,  6,  5,  4000000.00, '2018-09-01', 2018),
(3,  6,  5,  2500000.00, '2020-01-10', 2020),
-- Taj Mahal TTZ (project 6)
(1,  7,  6,   350000.00, '2019-02-01', 2019),
(6,  7,  6,   180000.00, '2022-03-01', 2022),
-- Kaziranga rhino corridor (project 7)
(1,  9,  7,   800000.00, '2022-05-01', 2022),
(7,  9,  7,   400000.00, '2023-03-01', 2023),
-- Mohenjo-daro emergency (project 8)
(1,  10, 8,  2000000.00, '2023-08-01', 2023),
(10, 10, 8,  1200000.00, '2023-08-15', 2023),
-- Lahore sheesh mahal (project 9)
(8,  12, 9,   500000.00, '2021-12-01', 2021),
(10, 12, 9,   180000.00, '2022-06-01', 2022),
-- Machu Picchu (project 10)
(1,  13, 10,  180000.00, '2022-02-01', 2022),
(11, 13, 10,   90000.00, '2022-03-01', 2022),
-- Chan Chan drainage (project 11)
(1,  15, 11, 2500000.00, '2023-11-01', 2023),
(3,  15, 11, 1200000.00, '2024-01-05', 2024),
-- Giza Sphinx groundwater (project 12)
(1,  16, 12,  900000.00, '2021-07-01', 2021),
(3,  16, 12,  600000.00, '2022-06-01', 2022),
-- Karnak laser-cleaning (project 13)
(1,  17, 13,  500000.00, '2023-03-01', 2023),
(11, 17, 13,  280000.00, '2023-04-01', 2023),
-- Chichen-Itza cenote (project 14)
(1,  19, 14,  320000.00, '2022-10-01', 2022),
(7,  19, 14,  160000.00, '2023-01-01', 2023),
-- Xochimilco remediation (project 15)
(1,  20, 15, 1200000.00, '2023-07-01', 2023),
(3,  20, 15,  700000.00, '2024-01-01', 2024),
-- Hiroshima humidity upgrade (project 16)
(5,  23, 16,  160000.00, '2022-05-01', 2022),
(1,  23, 16,   90000.00, '2022-06-01', 2022),
-- Shirakami invasive species (project 17)
(5,  24, 17,  400000.00, '2021-11-01', 2021),
(1,  24, 17,  180000.00, '2022-10-01', 2022),
-- Amazon early-warning (project 18)
(1,  25, 18, 1800000.00, '2022-02-01', 2022),
(3,  25, 18,  900000.00, '2023-01-05', 2023),
-- Iguaçu jaguar corridor (project 19)
(1,  26, 19, 1000000.00, '2023-04-01', 2023),
(6,  26, 19,  600000.00, '2023-05-01', 2023),
-- Petra flood channel (project 20)
(1,  28, 20, 1200000.00, '2022-08-01', 2022),
(8,  28, 20,  600000.00, '2023-01-01', 2023),
-- Stonehenge A303 (project 24)
(2,  34, 24, 800000000.00,'2023-12-01', 2023),
(9,  34, 24, 900000000.00,'2024-01-01', 2024),
-- General site allocations (no project)
(1,  11, NULL, 120000.00, '2023-06-01', 2023),
(1,  14, NULL, 200000.00, '2023-09-01', 2023),
(1,  18, NULL, 150000.00, '2023-11-01', 2023),
(1,  21, NULL, 280000.00, '2023-12-01', 2023),
(1,  22, NULL, 100000.00, '2024-01-01', 2024);


INSERT INTO AnnualReport (site_id, report_year, submission_date, visitor_count, total_revenue, conservation_spend, summary) VALUES
-- Italy
(1, 2022, '2023-03-15', 7200000, 28000000, 4200000, 'Strong visitor recovery post-pandemic; major colosseum restoration phase completed.'),
(1, 2023, '2024-03-10', 7800000, 31000000, 4600000, 'Record revenue year; new ticketing system reduced queues by 40%.'),
(1, 2024, '2025-02-28', 8100000, 33000000, 4900000, 'Continued growth; underground excavation project launched beneath the forum.'),
(2, 2022, '2023-03-20', 3600000, 18000000, 5100000, 'Flooding events required emergency barrier repairs; visitor caps introduced.'),
(2, 2023, '2024-03-15', 3200000, 16000000, 5400000, 'Visitor decline due to tighter access controls; MOSE barrier operational.'),
(2, 2024, '2025-03-01', 2900000, 14500000, 5800000, 'Deliberate overtourism reduction policy; conservation spend at record high.'),
(3, 2022, '2023-03-18', 4100000, 15000000, 2200000, 'Uffizi expansion complete; digital ticketing rolled out across key monuments.'),
(3, 2023, '2024-03-12', 4400000, 16500000, 2400000, 'Renaissance trail tourism up 12%; Ponte Vecchio structural survey completed.'),
(3, 2024, '2025-03-05', 4700000, 17800000, 2600000, 'New pedestrian zones boosted heritage access; Arno flood defences upgraded.'),
-- China
(4, 2022, '2023-04-01', 9500000, 42000000, 6100000, 'Post-lockdown visitor surge; northern sections repaired after winter damage.'),
(4, 2023, '2024-03-28', 10200000, 46000000, 6500000, 'New drone surveillance system deployed along 800km of monitored sections.'),
(4, 2024, '2025-03-20', 11000000, 50000000, 7000000, 'Erosion mitigation programme expanded; visitor routing AI system piloted.'),
(5, 2022, '2023-04-05', 14000000, 61000000, 3200000, 'Highest visitor numbers in history; south gate renovation completed.'),
(5, 2023, '2024-04-01', 15500000, 68000000, 3600000, 'New interpretive centre opened; imperial garden replanting programme underway.'),
(5, 2024, '2025-03-25', 16800000, 74000000, 4000000, 'Structural reinforcement of east wing; night tour programme launched.'),
(6, 2022, '2023-03-30', 820000, 9200000, 3800000, 'Earthquake recovery ongoing; trails reopened in phases throughout the year.'),
(6, 2023, '2024-03-25', 750000, 8400000, 4100000, 'Restricted zones maintained; lake water clarity monitoring intensified.'),
(6, 2024, '2025-03-18', 680000, 7600000, 4400000, 'Controlled visitor reduction policy sustained; biodiversity surveys positive.'),
-- India
(7, 2022, '2023-03-20', 6200000, 22000000, 3100000, 'Air pollution alert system installed; yellow stone treatment programme expanded.'),
(7, 2023, '2024-03-15', 6700000, 24000000, 3400000, 'Visitor cap enforcement strengthened; night viewing slots added.'),
(7, 2024, '2025-03-10', 7100000, 26000000, 3700000, 'Marble restoration phase 2 underway; river Yamuna cleanup initiative launched.'),
(8, 2022, '2023-03-25', 980000, 4200000, 1100000, 'New trail network mapped; monsoon damage to outer walls repaired.'),
(8, 2023, '2024-03-20', 1100000, 4800000, 1200000, 'Visitor growth 12%; solar lighting installed across the royal enclosure.'),
(8, 2024, '2025-03-15', 1250000, 5400000, 1400000, 'Community tourism programme launched; digital map kiosks installed at entry.'),
(9, 2022, '2023-03-28', 420000, 3100000, 2800000, 'Flood season severe; rhino population stable at 2,613 individuals.'),
(9, 2023, '2024-03-22', 390000, 2900000, 3000000, 'Anti-poaching operations intensified; flood early warning system upgraded.'),
(9, 2024, '2025-03-18', 360000, 2700000, 3200000, 'Visitor decline due to flood route closures; wildlife corridor expansion approved.'),
-- Pakistan
(10, 2022, '2023-04-10', 180000, 820000, 1200000, 'Groundwater salinity control measures implemented; UNESCO mission visited.'),
(10, 2023, '2024-04-05', 160000, 740000, 1400000, 'Emergency brick consolidation works on citadel mound; visitor decline noted.'),
(10, 2024, '2025-04-01', 140000, 660000, 1600000, 'Critical stabilisation works ongoing; international conservation team on site.'),
(11, 2022, '2023-04-08', 95000, 420000, 580000, 'Stupa excavation resumed; site boundary markers renewed.'),
(11, 2023, '2024-04-02', 88000, 390000, 620000, 'Conservation audit completed; visitor pathway resurfaced.'),
(11, 2024, '2025-03-28', 102000, 460000, 640000, 'Tourism uptick after regional road improvements; new site museum opened.'),
(12, 2022, '2023-04-12', 310000, 1400000, 920000, 'Fort restoration phase 1 complete; Shalamar garden water channels repaired.'),
(12, 2023, '2024-04-08', 290000, 1300000, 980000, 'Urban buffer encroachment documented; legal protections reviewed.'),
(12, 2024, '2025-04-03', 270000, 1200000, 1050000, 'Sheesh Mahal tile restoration underway; community heritage programme active.'),
-- Peru
(13, 2022, '2023-03-15', 1200000, 56000000, 8200000, 'Post-protest recovery; Inca Trail permit system tightened.'),
(13, 2023, '2024-03-10', 1100000, 51000000, 8800000, 'Deliberate visitor reduction; new carrying capacity study published.'),
(13, 2024, '2025-03-05', 980000, 46000000, 9400000, 'Sustainable tourism model adopted; terrace drainage restoration ongoing.'),
(14, 2022, '2023-03-18', 88000, 2100000, 1800000, 'Glacier monitoring stations upgraded; climate data shared with IPCC.'),
(14, 2023, '2024-03-12', 82000, 1950000, 1950000, 'Break-even conservation year; glacier retreat rate accelerating.'),
(14, 2024, '2025-03-08', 76000, 1800000, 2100000, 'Conservation spend now exceeds revenue; emergency UNESCO funding requested.'),
(15, 2022, '2023-03-22', 210000, 1800000, 1400000, 'Adobe wall consolidation complete on north ciudadela; visitor rerouted.'),
(15, 2023, '2024-03-18', 195000, 1680000, 1500000, 'Rainfall damage repaired; 3D scan of royal enclosure completed.'),
(15, 2024, '2025-03-12', 180000, 1540000, 1600000, 'New conservation laboratory opened on site; community archaeology project active.'),
-- Egypt
(16, 2022, '2023-03-25', 4800000, 38000000, 5200000, 'Sphinx restoration phase completed; new visitor centre opened at plateau.'),
(16, 2023, '2024-03-20', 5200000, 41000000, 5600000, 'Tourism surge following regional stability; sound and light show upgraded.'),
(16, 2024, '2025-03-15', 5700000, 45000000, 6000000, 'Record visitors; urban encroachment south of plateau formally documented.'),
(17, 2022, '2023-03-28', 1200000, 9400000, 2100000, 'Valley of the Kings new tomb opened; Karnak temple lighting upgraded.'),
(17, 2023, '2024-03-22', 1350000, 10600000, 2300000, 'Visitor growth 12.5%; agricultural pollution buffer zone established.'),
(17, 2024, '2025-03-18', 1480000, 11600000, 2500000, 'Digital documentation of all inscriptions complete; roof repair at Luxor temple.'),
(18, 2022, '2023-03-30', 680000, 5200000, 1800000, 'Lake Nasser water level management improved; temple facade cleaned.'),
(18, 2023, '2024-03-25', 720000, 5600000, 1900000, 'New visitor boat pier completed; desert erosion barriers installed.'),
(18, 2024, '2025-03-20', 760000, 5900000, 2000000, 'Conservation cooperation with Sudan formalised; night tours launched.'),
-- Mexico
(19, 2022, '2023-03-20', 2100000, 14000000, 1900000, 'Stone erosion programme phase 1 complete; cenote water quality improved.'),
(19, 2023, '2024-03-15', 2300000, 15400000, 2000000, 'New archaeo-astronomy interpretive trail opened; visitor record broken.'),
(19, 2024, '2025-03-10', 2500000, 16700000, 2200000, 'Pyramid climbing ban fully enforced; underground cenote survey launched.'),
(20, 2022, '2023-03-22', 5400000, 21000000, 3100000, 'Zócalo restoration complete; metro heritage integration project started.'),
(20, 2023, '2024-03-18', 5800000, 22600000, 3300000, 'Air quality improvements noted; Xochimilco chinampas restoration expanded.'),
(20, 2024, '2025-03-12', 6200000, 24200000, 3500000, 'Earthquake-resilience upgrades to colonial buildings; tourism up 7%.'),
(21, 2022, '2023-03-25', 320000, 4800000, 3600000, 'Coral reef monitoring expanded; sea turtle nesting season record high.'),
(21, 2023, '2024-03-20', 295000, 4400000, 3900000, 'Visitor reduction from storm damage; mangrove replanting 50 hectares.'),
(21, 2024, '2025-03-15', 270000, 4100000, 4200000, 'Conservation spend exceeds revenue; climate resilience plan adopted.'),
-- Japan
(22, 2022, '2023-03-15', 1800000, 8200000, 1400000, 'International tourism resumed post-COVID; temple restoration phase 2 complete.'),
(22, 2023, '2024-03-10', 2100000, 9600000, 1500000, 'Deer management programme reviewed; new multilingual signage installed.'),
(22, 2024, '2025-03-05', 2400000, 11000000, 1600000, 'Tourism boom from weak yen; Tōdai-ji main hall roof tiles replaced.'),
(23, 2022, '2023-03-18', 1200000, 5400000, 900000, 'Peace ceremony attendance record; dome illumination system upgraded.'),
(23, 2023, '2024-03-12', 1350000, 6100000, 950000, 'New peace education centre opened; structural survey of dome completed.'),
(23, 2024, '2025-03-08', 1500000, 6800000, 1000000, 'G7 leaders visit boosted global profile; dome stabilisation works approved.'),
(24, 2022, '2023-03-20', 140000, 1800000, 1600000, 'Beech forest health index excellent; trail erosion repairs completed.'),
(24, 2023, '2024-03-15', 128000, 1650000, 1750000, 'Visitor reduction policy maintained; climate impact study published.'),
(24, 2024, '2025-03-10', 115000, 1480000, 1900000, 'Conservation spend rising; beech regeneration corridors expanded.'),
-- Brazil
(25, 2022, '2023-04-01', 68000, 1200000, 4800000, 'Deforestation pressure increased; patrol network expanded by 30%.'),
(25, 2023, '2024-03-28', 58000, 1040000, 5200000, 'Drought event reduced river access; fire prevention barriers installed.'),
(25, 2024, '2025-03-22', 50000, 900000, 5600000, 'Conservation deficit widening; international emergency funding secured.'),
(26, 2022, '2023-03-25', 1850000, 18000000, 4200000, 'Waterfall flow at seasonal record; new pedestrian bridge opened.'),
(26, 2023, '2024-03-20', 1980000, 19300000, 4500000, 'Visitor growth 7%; forest buffer zone extended by 8,000 hectares.'),
(26, 2024, '2025-03-15', 2100000, 20500000, 4800000, 'Record visitors; Atlantic forest corridor with Argentina formalised.'),
(27, 2022, '2023-03-28', 620000, 4800000, 1100000, 'Baroque church facades restored; cobblestone street repairs completed.'),
(27, 2023, '2024-03-22', 680000, 5300000, 1200000, 'Heritage trail app launched; visitor growth 9.7%.'),
(27, 2024, '2025-03-18', 740000, 5800000, 1300000, 'Mining boundary protection strengthened; new heritage museum opened.'),
-- Jordan
(28, 2022, '2023-03-20', 1050000, 48000000, 3800000, 'Post-pandemic recovery strong; Treasury facade laser-cleaned.'),
(28, 2023, '2024-03-15', 1180000, 54000000, 4100000, 'Visitor growth 12%; new archaeological dig at Petra north revealed tombs.'),
(28, 2024, '2025-03-10', 1300000, 59000000, 4400000, 'Record revenue; rock facade consolidation programme phase 2 launched.'),
(29, 2022, '2023-03-22', 82000, 1400000, 620000, 'Fresco conservation treatment applied; desert access road resurfaced.'),
(29, 2023, '2024-03-18', 91000, 1560000, 660000, 'Visitor growth 11%; new interpretive panels installed inside bathhouse.'),
(29, 2024, '2025-03-12', 100000, 1720000, 700000, 'Humidity control system upgraded inside castle; tourism growing steadily.'),
(30, 2022, '2023-03-25', 340000, 8200000, 1800000, 'Bedouin community partnership programme launched; visitor centre expanded.'),
(30, 2023, '2024-03-20', 380000, 9200000, 1950000, 'Visitor growth 11.8%; new stargazing tourism zone designated.'),
(30, 2024, '2025-03-15', 420000, 10200000, 2100000, 'Strong growth continues; desert sandstone erosion monitoring expanded.'),
-- Kenya
(31, 2022, '2023-04-05', 210000, 6800000, 3200000, 'Glacier monitoring programme expanded; elephant corridor protection strengthened.'),
(31, 2023, '2024-04-01', 240000, 7800000, 3400000, 'Visitor growth 14%; community conservancy buffer zone formalised.'),
(31, 2024, '2025-03-28', 270000, 8800000, 3600000, 'Climate impact report published; alpine trail network upgraded.'),
(32, 2022, '2023-04-08', 48000, 1800000, 2400000, 'Fishing community sustainable use agreement signed; bird census completed.'),
(32, 2023, '2024-04-03', 52000, 1960000, 2600000, 'Visitor growth 8%; water pollution from informal settlements being addressed.'),
(32, 2024, '2025-03-30', 56000, 2120000, 2800000, 'Shoreline erosion control works completed; crocodile population stable.'),
(33, 2022, '2023-04-10', 98000, 2200000, 1100000, 'Coral reef survey positive; dhow harbour restoration complete.'),
(33, 2023, '2024-04-05', 110000, 2480000, 1200000, 'Visitor growth 12%; illegal construction enforcement strengthened.'),
(33, 2024, '2025-04-01', 122000, 2760000, 1300000, 'Heritage trail launched through old town; building height restrictions enforced.'),
-- United Kingdom
(34, 2022, '2023-03-15', 1200000, 9200000, 2100000, 'Solstice event record attendance; landscape management plan renewed.'),
(34, 2023, '2024-03-10', 1300000, 9980000, 2200000, 'Visitor growth 8.3%; new visitor experience tunnel opened.'),
(34, 2024, '2025-03-05', 1400000, 10740000, 2300000, 'A303 tunnel project progressing; winter solstice crowd record broken.'),
(35, 2022, '2023-03-18', 2800000, 32000000, 4200000, 'Crown Jewels gallery refurbished; moat biodiversity survey completed.'),
(35, 2023, '2024-03-12', 3000000, 34300000, 4400000, 'Visitor growth 7.1%; White Tower structural reinforcement approved.'),
(35, 2024, '2025-03-08', 3200000, 36600000, 4600000, 'Record revenue year; ravens health programme expanded.'),
(36, 2022, '2023-03-20', 980000, 6200000, 1800000, 'Coastal erosion survey completed; new viewpoint platforms installed.'),
(36, 2023, '2024-03-15', 1050000, 6640000, 1900000, 'Visitor growth 7.1%; column stability monitoring upgraded.'),
(36, 2024, '2025-03-10', 1120000, 7080000, 2000000, 'Erosion defences strengthened; geological monitoring network expanded.'),
-- Germany
(37, 2022, '2023-03-22', 1600000, 7800000, 1400000, 'Gothic stonework restoration phase 4 complete; organ renovation finished.'),
(37, 2023, '2024-03-18', 1720000, 8400000, 1500000, 'Visitor growth 7.5%; new treasury exhibition opened.'),
(37, 2024, '2025-03-12', 1840000, 8980000, 1600000, 'Rhine waterfront heritage zone extended; stained glass restoration underway.'),
(38, 2022, '2023-03-25', 2200000, 11000000, 2100000, 'Sanssouci roof restoration complete; new vineyard terracing restored.'),
(38, 2023, '2024-03-20', 2380000, 11900000, 2200000, 'Visitor growth 8.2%; Babelsberg park historical rose garden replanted.'),
(38, 2024, '2025-03-15', 2560000, 12800000, 2300000, 'Record visitors; Charlottenhof palace interior reopened after renovation.'),
(39, 2022, '2023-03-28', 42000, 980000, 1200000, 'New fossil specimen extraction completed; visitor centre refurbished.'),
(39, 2023, '2024-03-22', 46000, 1080000, 1280000, 'Visitor growth 9.5%; international research partnerships expanded.'),
(39, 2024, '2025-03-18', 50000, 1180000, 1360000, 'Eocene research paper published; new stratigraphic mapping completed.'),
-- France
(40, 2022, '2023-03-20', 2600000, 18000000, 3200000, 'Tidal causeway renovation complete; new pilgrimage interpretive trail opened.'),
(40, 2023, '2024-03-15', 2780000, 19260000, 3360000, 'Visitor growth 7%; abbey roof tile replacement phase 1 complete.'),
(40, 2024, '2025-03-10', 2960000, 20520000, 3520000, 'Bay erosion monitoring intensified; new visitor management plan adopted.'),
(41, 2022, '2023-03-22', 6800000, 42000000, 5800000, 'Grand canal restoration complete; Hall of Mirrors fully reopened.'),
(41, 2023, '2024-03-18', 7200000, 44520000, 6000000, 'Visitor growth 5.9%; new multimedia palace history exhibition launched.'),
(41, 2024, '2025-03-12', 7600000, 47040000, 6200000, 'Record attendance; garden irrigation system overhauled for drought resilience.'),
(42, 2022, '2023-03-25', 280000, 3200000, 2800000, 'Lascaux IV replica expanded; cave humidity stabilised after intervention.'),
(42, 2023, '2024-03-20', 260000, 2980000, 3000000, 'Visitor reduction from cave closure; emergency humidity system installed.'),
(42, 2024, '2025-03-15', 240000, 2760000, 3200000, 'Conservation spend exceeds revenue; cave microbiome study published.'),
-- Spain
(43, 2022, '2023-03-18', 2400000, 16000000, 2800000, 'Nasrid palace plasterwork restored; new night tour programme launched.'),
(43, 2023, '2024-03-12', 2580000, 17200000, 2950000, 'Visitor growth 7.5%; Generalife water garden channels repaired.'),
(43, 2024, '2025-03-08', 2760000, 18400000, 3100000, 'Ticket cap raised by 5%; Albayzín neighbourhood heritage trail opened.'),
(44, 2022, '2023-03-20', 4800000, 28000000, 3600000, 'Sagrada Família nave towers completed; new crypt museum opened.'),
(44, 2023, '2024-03-15', 5100000, 29760000, 3800000, 'Visitor growth 6.25%; Park Güell vegetation restoration complete.'),
(44, 2024, '2025-03-10', 5400000, 31520000, 4000000, 'Sagrada Família central tower nearing completion; record year for visits.'),
(45, 2022, '2023-03-22', 580000, 8400000, 6200000, 'Wetland water levels critically low; emergency water diversion approved.'),
(45, 2023, '2024-03-18', 520000, 7560000, 6800000, 'Visitor reduction due to drought; lynx population stable at 23 individuals.'),
(45, 2024, '2025-03-12', 460000, 6720000, 7400000, 'Conservation deficit severe; EU emergency ecological funding granted.');


SELECT
    hs.site_id,
    hs.site_name,
    c.country_name,
    c.region,
    hc.category_name,
    hs.inscription_year,
    hs.area_hectares,
    IF(hs.is_endangered, 'YES', 'NO') AS on_danger_list
FROM HeritageSite hs
JOIN Country c          ON hs.country_id  = c.country_id
JOIN HeritageCategory hc ON hs.category_id = hc.category_id
ORDER BY hs.inscription_year;


SELECT
    hs.site_name,
    c.country_name,
    cs.status_label,
    cs.risk_level,
    cr.assessment_date,
    cr.notes
FROM HeritageSite hs
JOIN Country c                  ON hs.country_id  = c.country_id
JOIN ConservationRecord cr      ON hs.site_id     = cr.site_id
JOIN ConservationStatus cs      ON cr.status_id   = cs.status_id
WHERE hs.is_endangered = 1
  AND cr.assessment_date = (
        SELECT MAX(cr2.assessment_date)
        FROM ConservationRecord cr2
        WHERE cr2.site_id = hs.site_id
  );


SELECT
    hs.site_name,
    c.country_name,
    COUNT(v.visit_id)           AS total_visits,
    SUM(v.group_size)           AS total_visitors,
    SUM(v.revenue_usd)          AS total_revenue_usd,
    ROUND(AVG(v.feedback_score),2) AS avg_feedback
FROM HeritageSite hs
JOIN Country c  ON hs.country_id = c.country_id
LEFT JOIN Visit v ON hs.site_id  = v.site_id
GROUP BY hs.site_id, hs.site_name, c.country_name
ORDER BY total_revenue_usd DESC;



SELECT
    ti.incident_id,
    hs.site_name,
    c.country_name,
    tc.category_name                        AS threat_type,
    ti.severity,
    ti.incident_date,
    ti.description
FROM ThreatIncident ti
JOIN HeritageSite hs    ON ti.site_id       = hs.site_id
JOIN Country c          ON hs.country_id    = c.country_id
JOIN ThreatCategory tc  ON ti.threat_cat_id = tc.threat_cat_id

WHERE ti.resolved = 0
  AND ti.severity IN ('High','Critical')
ORDER BY ti.severity DESC, ti.incident_date;


SELECT
    tc.category_name,
    COUNT(*)                            AS total_incidents,
    SUM(ti.resolved)                    AS resolved_count,
    COUNT(*) - SUM(ti.resolved)         AS open_count,
    ROUND(SUM(ti.resolved)/COUNT(*)*100,1) AS resolution_rate_pct
FROM ThreatIncident ti
JOIN ThreatCategory tc ON ti.threat_cat_id = tc.threat_cat_id
GROUP BY tc.category_name
ORDER BY total_incidents DESC;

SELECT
    hs.site_name,
    c.country_name,
    COUNT(fa.allocation_id)         AS funding_tranches,
    SUM(fa.amount_usd)              AS total_funded_usd
FROM FundingAllocation fa
JOIN HeritageSite hs ON fa.site_id = hs.site_id
JOIN Country c       ON hs.country_id = c.country_id
GROUP BY hs.site_id, hs.site_name, c.country_name
ORDER BY total_funded_usd DESC;

SELECT
    fs.source_type,
    fa.fiscal_year,
    COUNT(fa.allocation_id)     AS allocations,
    SUM(fa.amount_usd)          AS total_amount_usd
FROM FundingAllocation fa
JOIN FundingSource fs ON fa.fund_id = fs.fund_id
GROUP BY fs.source_type, fa.fiscal_year
ORDER BY fa.fiscal_year, total_amount_usd DESC;


SELECT
    hs.site_name,
    c.country_name,
    cs.status_label,
    cr.assessment_date
FROM HeritageSite hs
JOIN Country c ON hs.country_id = c.country_id
JOIN ConservationRecord cr ON hs.site_id = cr.site_id
JOIN ConservationStatus cs ON cr.status_id = cs.status_id
WHERE cr.assessment_date = (
    SELECT MAX(cr2.assessment_date)
    FROM ConservationRecord cr2
    WHERE cr2.site_id = hs.site_id
)
  AND cs.status_label IN ('Critical','Fair')
ORDER BY cs.risk_level DESC;

SELECT
    hs.site_name,
    SUM(v.revenue_usd) AS total_revenue
FROM Visit v
JOIN HeritageSite hs ON v.site_id = hs.site_id
GROUP BY hs.site_id, hs.site_name
ORDER BY total_revenue DESC
LIMIT 5;

SELECT
    YEAR(visit_date)                AS yr,
    MONTH(visit_date)               AS mth,
    MONTHNAME(visit_date)           AS month_name,
    COUNT(visit_id)                 AS visit_count,
    SUM(group_size)                 AS visitors,
    SUM(revenue_usd)                AS revenue_usd
FROM Visit
WHERE YEAR(visit_date) = 2023
GROUP BY yr, mth, month_name
ORDER BY mth;


SELECT
    v.full_name,
    v.nationality,
    COUNT(DISTINCT vi.site_id)  AS sites_visited,
    COUNT(vi.visit_id)          AS total_visits,
    SUM(vi.revenue_usd)         AS total_spent_usd
FROM Visitor v
JOIN Visit vi ON v.visitor_id = vi.visitor_id
WHERE v.visitor_id IN (
    SELECT visitor_id
    FROM Visit
    GROUP BY visitor_id
    HAVING COUNT(DISTINCT site_id) > 1
)
GROUP BY v.visitor_id, v.full_name, v.nationality
ORDER BY sites_visited DESC;


SELECT
    hs.site_name,
    c.country_name,
    hc.category_name,
    hs.inscription_year
FROM HeritageSite hs
JOIN Country c           ON hs.country_id  = c.country_id
JOIN HeritageCategory hc ON hs.category_id = hc.category_id
WHERE hs.site_id NOT IN (
    SELECT DISTINCT site_id FROM ThreatIncident
)
ORDER BY hs.site_name;


SELECT
    cp.project_name,
    hs.site_name,
    fs.source_name,
    fs.source_type,
    fa.amount_usd,
    fa.fiscal_year
FROM FundingAllocation fa
JOIN ConservationProject cp ON fa.project_id = cp.project_id
JOIN HeritageSite hs        ON fa.site_id    = hs.site_id
JOIN FundingSource fs       ON fa.fund_id    = fs.fund_id
ORDER BY cp.project_name, fa.fiscal_year;


SELECT
    hs.site_name,
    ar.report_year,
    ar.visitor_count,
    ar.total_revenue,
    ar.conservation_spend,
    ROUND(ar.conservation_spend / ar.total_revenue * 100, 1)
        AS conservation_as_pct_revenue,
    ar.summary
FROM AnnualReport ar
JOIN HeritageSite hs ON ar.site_id = hs.site_id
ORDER BY hs.site_name, ar.report_year;


SELECT
    hs.site_name,
    sz.zone_name,
    sz.zone_type,
    sz.area_hectares,
    ROUND(sz.area_hectares / hs.area_hectares * 100, 2) AS pct_of_total_area
FROM SiteZone sz
JOIN HeritageSite hs ON sz.site_id = hs.site_id
ORDER BY hs.site_name, sz.zone_type;


SELECT
    hs.site_name,
    c.country_name,
    COUNT(ti.incident_id)                   AS total_incidents,
    SUM(ti.resolved)                        AS resolved,
    COUNT(ti.incident_id)-SUM(ti.resolved)  AS open_incidents,
    GROUP_CONCAT(DISTINCT tc.category_name ORDER BY tc.category_name SEPARATOR ', ')
                                            AS threat_types
FROM ThreatIncident ti
JOIN HeritageSite hs    ON ti.site_id       = hs.site_id
JOIN Country c          ON hs.country_id    = c.country_id
JOIN ThreatCategory tc  ON ti.threat_cat_id = tc.threat_cat_id
GROUP BY hs.site_id, hs.site_name, c.country_name
HAVING total_incidents >= 3
ORDER BY total_incidents DESC;

SELECT
    hs.site_name,
    c.country_name,
    ROUND(AVG(v.feedback_score),2)  AS avg_feedback,
    COUNT(v.visit_id)               AS total_reviews
FROM Visit v
JOIN HeritageSite hs ON v.site_id    = hs.site_id
JOIN Country c       ON hs.country_id = c.country_id
WHERE v.feedback_score IS NOT NULL
GROUP BY hs.site_id, hs.site_name, c.country_name
HAVING avg_feedback < 4.0
ORDER BY avg_feedback ASC;

SELECT
    hs.site_name,
    cr.assessment_date  AS last_assessed,
    cr.next_review,
    cs.status_label,
    DATEDIFF(cr.next_review, CURDATE()) AS days_until_review
FROM ConservationRecord cr
JOIN HeritageSite hs    ON cr.site_id    = hs.site_id
JOIN ConservationStatus cs ON cr.status_id = cs.status_id
WHERE cr.next_review BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
ORDER BY cr.next_review;


SELECT
    hs.site_name,
    c.country_name,
    hc.category_name,
    hs.inscription_year,
    IF(hs.is_endangered,'Endangered','Safe')                    AS danger_status,
    cs_latest.status_label                                      AS conservation_status,
    COALESCE(SUM(DISTINCT fa.amount_usd), 0)                    AS total_funding_usd,
    COALESCE(visit_agg.total_visitors, 0)                       AS total_visitors,
    COALESCE(threat_agg.open_threats, 0)                        AS open_threats,
    COALESCE(project_agg.active_projects, 0)                    AS active_projects
FROM HeritageSite hs
JOIN Country c               ON hs.country_id   = c.country_id
JOIN HeritageCategory hc     ON hs.category_id  = hc.category_id

JOIN ConservationRecord cr   ON hs.site_id      = cr.site_id
    AND cr.assessment_date   = (SELECT MAX(cr2.assessment_date)
                                FROM ConservationRecord cr2
                                WHERE cr2.site_id = hs.site_id)
JOIN ConservationStatus cs_latest ON cr.status_id = cs_latest.status_id
LEFT JOIN FundingAllocation fa ON fa.site_id     = hs.site_id

LEFT JOIN (
    SELECT site_id, SUM(group_size) AS total_visitors
    FROM Visit GROUP BY site_id
) visit_agg ON visit_agg.site_id = hs.site_id

LEFT JOIN (
    SELECT site_id, COUNT(*) AS open_threats
    FROM ThreatIncident WHERE resolved = 0
    GROUP BY site_id
) threat_agg ON threat_agg.site_id = hs.site_id

LEFT JOIN (
    SELECT site_id, COUNT(*) AS active_projects
    FROM ConservationProject
    WHERE status = 'Ongoing'
    GROUP BY site_id
) project_agg ON project_agg.site_id = hs.site_id
GROUP BY
    hs.site_id, hs.site_name, c.country_name, hc.category_name,
    hs.inscription_year, hs.is_endangered, cs_latest.status_label,
    visit_agg.total_visitors, threat_agg.open_threats, project_agg.active_projects
ORDER BY open_threats DESC, hs.site_name;


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
FROM ConservationProject cp
JOIN HeritageSite hs ON cp.site_id = hs.site_id
LEFT JOIN FundingAllocation fa ON cp.project_id = fa.project_id
GROUP BY cp.project_id, cp.project_name, hs.site_name, cp.status, cp.budget_usd
ORDER BY funding_gap_usd DESC;


