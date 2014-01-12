#!/usr/bin/env ruby

require 'sqlite3'

def dm_create_views_concept_yes_and_no(dbFile, concept_id, table)
  db = SQLite3::Database.open dbFile 

  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]
  concept_v.length.times do |i|
    result_v = "#{concept_v[i]}_#{table}"
    query = "SELECT #{table}.* FROM #{concept_v[i]}, #{table} WHERE #{table}.rowid=#{concept_v[i]}.id;"
    cmd = "CREATE VIEW IF NOT EXISTS #{result_v} AS #{query};" 
    rs = db.execute cmd 
    
    # DEBUG
    cmd = "SELECT COUNT(*) FROM #{result_v};" 
    rs = db.execute cmd 
    rs.each {|row| puts "#{result_v}: #{row}"}

#    cmd = "DROP VIEW #{result_v}"
#    rs = db.execute cmd 
  end

  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db
 
  return concept_v
end

# ======== main =============
@dbFile = ARGV[0] 
concept_count = 94
table = 'AutoColorCorrelogram_CEDD_ColorLayout_EdgeHistogram_FCTH_Gabor_JCD_JpegCH_ScalableColor_Tamura'

if __FILE__ == 0
  concept_count.times do |i|
    dm_create_views_concept_yes_and_no(@dbFile, i, table) # concept x yes/no x feature views
  end
end
