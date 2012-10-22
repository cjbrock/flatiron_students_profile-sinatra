require 'sqlite3'

dbname = "students.db"
File.delete(dbname) if File.exists?(dbname)
db = SQLite3::Database.new (dbname)

rows = db.execute <<-SQL
	CREATE TABLE student_test_table (
		id INTEGER PRIMARY KEY,
		name TEXT,
		email TEXT
	);
SQL

db.execute <<-SQL
INSERT INTO student_test_table (name, email) 
	VALUES
	("rex", "rex@gmail.com"),
	("jenya", "jenya@gmail.com"),
	("david", "david@gmail.com"),
	("corinna", "corinna@gmail.com");
SQL