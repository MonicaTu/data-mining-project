#!/usr/bin/ruby

require 'sqlite3'

def combine_tables(left, right)
  newTable = "#{left}_#{right}"
  cmd = "CREATE TABLE IF NOT EXISTS #{newTable} as select #{left}.*, #{right}.* from #{left}, #{right} where #{left}.rowid=#{right}.rowid;"
  @db.execute cmd 

  # DEBUG
  cmd = "SELECT COUNT(*) FROM #{newTable};"
  rs = @db.execute cmd 
  puts "#{newTable}: #{rs}"

  return newTable 
end

begin
  dbFile = ARGV[0]
  p dbFile
  features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH',	'ScalableColor', 'Tamura']				       

  @db = SQLite3::Database.open dbFile

  newTable = features[0]
  features.count.times do |i|
    newTable = combine_tables(newTable, features[i+1]) if i != features.count-1
  end
  
  rescue SQLite3::Exception => e 
  puts "Exception occured"
  puts e
  ensure

  @db.close if @db
end
