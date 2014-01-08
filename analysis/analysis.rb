#!/usr/bin/env ruby

require 'sqlite3'
require 'descriptive_statistics'

def create_concept_feature_views
  94.times do |i|
    create_view_for_concept(i) # concept x yes/no views
  end

  94.times do |i|
    10.times do |j|
      create_view_for_concept_feature(i, j) # concept x yes/no x feature views
    end
  end
end

def create_view_for_concept(concept_id)
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]

  query = "SELECT UUID.id FROM Concepts, UUID WHERE Concepts.id=#{concept_id} and Concepts.uuid_id=UUID.uuid"
  @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{concept_v[0]} AS #{query}"
  rs = @stm.execute

  query = "SELECT id FROM UUID EXCEPT SELECT id FROM #{concept_v[0]}"
  @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{concept_v[1]} AS #{query}"
  rs = @stm.execute

#  concept_v.length.times do |i|
#    @stm = @db.prepare "DROP VIEW #{concept_v[i]}"
#    rs = @stm.execute
#  end
end

def create_view_for_concept_feature(concept_id, feature_id)
  feature_t = "#{@features[feature_id]}_stat"
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]
  concept_v.length.times do |i|
    result_v = "#{feature_t}_#{concept_v[i]}"
    query = "SELECT #{feature_t}.* FROM #{concept_v[i]}, #{feature_t} WHERE #{feature_t}.rowid=#{concept_v[i]}.id"
    @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{result_v} AS #{query}" 
    rs = @stm.execute

#    @stm = @db.prepare "DROP VIEW #{result_v}"
#    rs = @stm.execute
  end
end

# calcuate means and stddev of an instance
def cal_means_and_stddev
  @features.each do |feature|
    means = []
    stddevs = []

    table = feature
    @stm = @db.prepare "SELECT * FROM #{table}" 
    rs = @stm.execute 
    rs.each do |row|
      means << row.mean
      stddevs << row.standard_deviation
    end

    # save mean & stddev into statistic table
    table = "#{feature}_stat"
    p table
    @stm = @db.prepare "CREATE TABLE IF NOT EXISTS #{table} (mean integer, stddev integer);" 
    rs = @stm.execute 
    if means.length == stddevs.length
      means.length.times do |i|
        @stm = @db.prepare "INSERT INTO #{table} VALUES (#{means[i]}, #{stddevs[i]})"
        rs = @stm.execute 
      end
    else
      puts "[DEBUG] Should not be here!" + __LINE__
    end
  end
end

def count_concepts
  94.times do |i|  
    @stm = @db.prepare "SELECT COUNT(*) FROM Concepts WHERE id=#{i}" 
    rs = @stm.execute
    rs.each do |row|
      puts row
    end
  end
end

# ======== main =============
@filename = ARGV[0] 

@features = ["AutoColorCorrelogram", "CEDD", "ColorLayout", "EdgeHistogram", "FCTH", "Gabor", "JCD", "JpegCH", "ScalableColor", "Tamura"]

begin
  @db = SQLite3::Database.open @filename 
#  cal_means_and_stddev
#  create_concept_feature_views
#  count_concepts
rescue SQLite3::Exception => e 
  puts "Exception occured"
  puts e
ensure
  @stm.close if @stm
  @db.close if @db
end
