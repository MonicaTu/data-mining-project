#!/usr/bin/env ruby

require 'sqlite3'

def create_concept_feature_views(concept_count, feature_count)
  concept_count.times do |i|
    create_view_for_concept(i) # concept x yes/no views
  end

  concept_count.times do |i|
    feature_count.times do |j|
      create_view_for_concept_feature(i, j) # concept x yes/no x feature views
    end
  end
end

def create_view_for_concept(concept_id)
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]

  query = "SELECT UUID.id FROM Concepts, UUID WHERE Concepts.id=#{concept_id} and Concepts.uuid_id=UUID.uuid;"
  @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{concept_v[0]} AS #{query};"
  rs = @stm.execute
  # DEBUG
  @stm = @db.prepare "SELECT COUNT(*) FROM #{concept_v[0]};" 
  rs = @stm.execute
  rs.each {|row| puts "#{concept_v[0]}: #{row}"}

  query = "SELECT id FROM UUID EXCEPT SELECT id FROM #{concept_v[0]};"
  @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{concept_v[1]} AS #{query};"
  rs = @stm.execute
  # DEBUG
  @stm = @db.prepare "SELECT COUNT(*) FROM #{concept_v[1]};" 
  rs = @stm.execute
  rs.each {|row| puts "#{concept_v[1]}: #{row}"}

#  concept_v.length.times do |i|
#    @stm = @db.prepare "DROP VIEW #{concept_v[i]}"
#    rs = @stm.execute
#  end
end

def create_view_for_concept_feature(concept_id, feature_id)
  feature_t = "#{@features[feature_id]}"
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]
  concept_v.length.times do |i|
    result_v = "#{concept_v[i]}_#{feature_t}"
    query = "SELECT #{feature_t}.* FROM #{concept_v[i]}, #{feature_t} WHERE #{feature_t}.rowid=#{concept_v[i]}.id"
    @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{result_v} AS #{query}" 
    rs = @stm.execute
    # DEBUG
    @stm = @db.prepare "SELECT COUNT(*) FROM #{result_v};" 
    rs = @stm.execute
    rs.each {|row| puts "#{result_v}: #{row}"}

#    @stm = @db.prepare "DROP VIEW #{result_v}"
#    rs = @stm.execute
  end
end

# ======== main =============
@dbFile = ARGV[0] 
@features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']

begin
  @db = SQLite3::Database.open @dbFile 
  concept_count = 94
  create_concept_feature_views(concept_count, @features.count)
rescue SQLite3::Exception => e 
  puts "Exception occured"
  puts e
ensure
  @stm.close if @stm
  @db.close if @db
end
