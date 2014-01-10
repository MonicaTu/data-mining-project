#!/usr/bin/env ruby

require 'sqlite3'

def dm_create_concept_feature_views(dbFile, concept_count, features)
  concept_count.times do |i|
    create_view_for_concept(dbFile, i) # concept x yes/no views
  end

  concept_count.times do |i|
    features.count.times do |j|
      create_view_for_concept_feature(dbFile, i, j, features) # concept x yes/no x feature views
    end
  end
end

def create_view_for_concept(dbFile, concept_id)
  db = SQLite3::Database.open dbFile

  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]

  query = "SELECT UUID.id FROM Concepts, UUID WHERE Concepts.id=#{concept_id} and Concepts.uuid_id=UUID.uuid;"
  cmd = "CREATE VIEW IF NOT EXISTS #{concept_v[0]} AS #{query};"
  rs = db.execute cmd 
  # DEBUG
  cmd = "SELECT COUNT(*) FROM #{concept_v[0]};" 
  rs = db.execute cmd 
  rs.each {|row| puts "#{concept_v[0]}: #{row}"}

  query = "SELECT id FROM UUID EXCEPT SELECT id FROM #{concept_v[0]};"
  cmd = "CREATE VIEW IF NOT EXISTS #{concept_v[1]} AS #{query};"
  rs = db.execute cmd 
  # DEBUG
  cmd = "SELECT COUNT(*) FROM #{concept_v[1]};" 
  rs = db.execute cmd 
  rs.each {|row| puts "#{concept_v[1]}: #{row}"}

#  concept_v.length.times do |i|
#    cmd = "DROP VIEW #{concept_v[i]}"
#    rs = db.execute cmd 
#  end

  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db
end

def create_view_for_concept_feature(dbFile, concept_id, feature_id, features)
  db = SQLite3::Database.open dbFile

  feature_t = "#{features[feature_id]}"
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]
  concept_v.length.times do |i|
    result_v = "#{concept_v[i]}_#{feature_t}"
    query = "SELECT #{feature_t}.* FROM #{concept_v[i]}, #{feature_t} WHERE #{feature_t}.rowid=#{concept_v[i]}.id"
    cmd = "CREATE VIEW IF NOT EXISTS #{result_v} AS #{query}" 
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
end

# ======== main =============
if __FILE__ == $0
  dbFile = ARGV[0] 
  features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
  
  db = SQLite3::Database.open dbFile 
  begin
    concept_count = 94
    dm_create_concept_feature_views(dbFile, concept_count, features)
  rescue SQLite3::Exception => e 
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end
