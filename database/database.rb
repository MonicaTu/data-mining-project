#!/usr/bin/env ruby

require 'sqlite3'

def db_create_database(dbFile)
  db = SQLite3::Database.open dbFile
  db.close if db
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
  exe("sqlite3 #{db} << #{cmd}")
end

def db_export_table(db, table)
  output = "#{table}.csv" 
  cmd = "!
.mode csv
.headers on
.output #{output}
SELECT * FROM #{table};
!"
  exe("sqlite3 #{db} << #{cmd}") 
  return output
end

def db_combine_tables(dbFile, left, right)
  db = SQLite3::Database.open dbFile

  newTable = "#{left}_#{right}"
  cmd = "CREATE TABLE IF NOT EXISTS #{newTable} as select #{left}.*, #{right}.* from #{left}, #{right} where #{left}.rowid=#{right}.rowid;"
  db.execute cmd 

  # DEBUG
  cmd = "SELECT COUNT(*) FROM #{newTable};"
  rs = db.execute cmd 
  puts "#{newTable}: #{rs}"

  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db

  return newTable 
end

def exe(sh)
  # sh: shell script
  puts sh
  %x{#{sh}}
end

