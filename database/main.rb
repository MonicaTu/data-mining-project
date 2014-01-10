#!/usr/bin/env ruby

require_relative 'database'
require_relative 'dm_create_concept_feature_views'
require_relative 'dm_export_concept_feature'

def initial_database
  db_create_database(@db)
  # uuid
  table = 'UUID'
  schema = 'id integer, uuid text'
  db_create_table_schema(@db, table, schema)

  # concepts
  table = 'Concepts'
  schema = 'id integer, uuid_id text'
  db_create_table_schema(@db, table, schema)

  # features
  @features.each_with_index do |feature, i|
    schema = schema_of_feature(feature, @features_num[i])
    db_create_table_schema(@db, feature, schema)
  end

  # import data
  import_concepts_and_features
end

def import_concepts_and_features
  db_import_csv(@db, 'UUID', '../train_id.csv')
  db_import_csv(@db, 'Concepts', '../concepts/concepts.csv')
  
  @features.each do |feature|
    csv = "../../Train/train_features/ImageCLEF 2012 (training) - #{feature}.csv" 
    db_import_csv(@db, feature, csv)
  end
end

def create_concept_feature_views
  dm_create_concept_feature_views(@db, @concept_num, @features)
end

def export_concepts_and_features
  @concept_num.times do |i|
    concept = "c#{i}"
    @features.each do |feature|
      dm_export_concept_feature(@db, concept, feature)
    end
  end
end

#====================================

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

def exe(sh)
  # sh: shell script
  puts sh
  %x{#{sh}}
end

begin
  @db = ARGV[0]
  if @db == nil 
    return 
  end

  @features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
  @features_num = [256, 144, 120, 80, 192, 60, 168, 192, 64, 18]
  @concept_num = 94

#  initial_database
  create_concept_feature_views
  export_concepts_and_features
  
#  exe("./db_import_normalized.rb #{@db}")
#  exe("./db_create_views.rb #{@db}")

#  exe("./db_integrate_tables.rb #{@db}")
#  exe("./db_integrate_views.rb #{@db}")
#  exe("./db_export.rb #{@db}")
end
