#!/usr/bin/env ruby

require 'sqlite3'

def db_create_database(dbFile)
  SQLite3::Database.open dbFile
end

def db_create_table_schema(dbFile, table, schema)
  db = SQLite3::Database.open dbFile
  begin
    cmd = "CREATE TABLE IF NOT EXISTS #{table} (#{schema});"
    db.execute cmd 
  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end

def db_import_csv(db, table, csv)
  cmd = "!
.separator ,
.import '#{csv}' #{table}
SELECT COUNT(*) FROM #{table};
!"
  # shell script
  sh = "sqlite3 #{db} << #{cmd}"
  puts sh
  %x{#{sh}}
end

