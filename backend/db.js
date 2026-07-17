const mysql = require('mysql2');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'Yashfa015@',
  database: 'heritage_monitoring',
  waitForConnections: true
});

module.exports = pool.promise();