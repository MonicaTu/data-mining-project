#!/usr/bin/env ruby

require 'sqlite3'

def create_concept_feature_views(concept_count, table)
  concept_count.times do |i|
    create_view_for_concept_feature(i, table) # concept x yes/no x feature views
  end
end

def create_view_for_concept_feature(concept_id, table)
  concept_v = ["c#{concept_id}_yes", "c#{concept_id}_no"]
  concept_v.length.times do |i|
    result_v = "#{concept_v[i]}_#{table}"
    query = "SELECT #{table}.* FROM #{concept_v[i]}, #{table} WHERE #{table}.rowid=#{concept_v[i]}.id;"
    @stm = @db.prepare "CREATE VIEW IF NOT EXISTS #{result_v} AS #{query};" 
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
table = 'AutoColorCorrelogram_CEDD_ColorLayout_EdgeHistogram_FCTH_Gabor_JCD_JpegCH_ScalableColor_Tamura'

begin
  @db = SQLite3::Database.open @dbFile 
  concept_count = 94
  create_concept_feature_views(concept_count, table)
rescue SQLite3::Exception => e 
  puts "Exception occured"
  puts e
ensure
  @stm.close if @stm
  @db.close if @db
end
