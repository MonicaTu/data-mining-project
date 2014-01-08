#!/usr/bin/ruby

# ==========================================
# http://zetcode.com/db/sqliteruby/connect/
# ==========================================

require 'sqlite3'

def schema_of_feature(name, num)
  schema = "" 
  num.times do |index|
    if index == num-1
      schema = schema +  "#{name}#{index} float"
    else
      schema = schema +  "#{name}#{index} float, "
    end
  end
  return schema
end

begin
  dbFile = ARGV[0]
  p dbFile

  db = SQLite3::Database.open dbFile

  # train_id
  cmd = "CREATE TABLE IF NOT EXISTS UUID (id integer, uuid text);"
  db.execute cmd 

  # concepts
  cmd = "CREATE TABLE IF NOT EXISTS Concepts (id integer, uuid_id text);"
  db.execute cmd 

  # features
  features = [['AutoColorCorrelogram', 256],
              ['CEDD',				         144],
              ['ColorLayout',				   120],
              ['EdgeHistogram',				  80],
              ['FCTH',				         192],
              ['Gabor',				          60],
              ['JCD',				           168],
              ['JpegCH',				       192],
              ['ScalableColor',				  64],
              ['Tamura',				        18]]
  features.each do |f|
    cmd = "CREATE TABLE IF NOT EXISTS #{f[0]} (#{schema_of_feature(f[0], f[1])});"
    db.execute cmd 
  end
  
  rescue SQLite3::Exception => e 
  puts "Exception occured"
  puts e
  ensure

  db.close if db
end
