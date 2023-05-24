const mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "yourPassword...",
  database: "kummadb"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
  con.query("SELECT * FROM driver", function (err, result, fields) {
    if (err) throw err;
    console.log(result);
  });
});