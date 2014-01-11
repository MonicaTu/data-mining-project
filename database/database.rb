#!/usr/bin/env ruby

require 'sqlite3'
require_relative 'system'

def db_create_database(dbFile)
  db = SQLite3::Database.open dbFile
  db.close if db
end

def db_create_table_schema(dbFile, table, schema)
  cmd = "CREATE TABLE IF NOT EXISTS #{table} (#{schema});"
  exesql(dbFile, cmd)
end

def db_import_csv(db, table, csv)
  cmd = "!
.separator ,
.import '#{csv}' #{table}
SELECT COUNT(*) FROM #{table};
!"
  # shell script
  exesh("sqlite3 #{db} << #{cmd}")
end

def db_export_table(db, table)
  output = "#{table}.csv" 
  cmd = "!
.mode csv
.headers on
.output #{output}
SELECT * FROM #{table};
!"
  exesh("sqlite3 #{db} << #{cmd}") 
  return output
end

def db_combine_tables(dbFile, left, right)

  newTable = "#{left}_#{right}"
  cmd = "CREATE TABLE IF NOT EXISTS #{newTable} as select #{left}.*, #{right}.* from #{left}, #{right} where #{left}.rowid=#{right}.rowid;"
  exesql(dbFile, cmd)

  # DEBUG
  cmd = "SELECT COUNT(*) FROM #{newTable};"
  rs = exesql(dbFile, cmd)
  puts "#{newTable}: #{rs}"

  return newTable 
end

def db_drop_table(dbFile, table)
  puts "---------!!!!--------"
  cmd = "DROP TABLE #{table};"
  exesql(dbFile, cmd)
end

def exesql(dbFile, cmd)
  puts cmd

  db = SQLite3::Database.open dbFile
  rs = db.execute cmd 
  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db

  return rs
end
