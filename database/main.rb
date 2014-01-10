#!/usr/bin/env ruby

require_relative 'database'
require_relative 'db_export_concept_feature'

def initial_database(dbFile)
  db_create_database(dbFile)
  # uuid
  table = 'UUID'
  schema = 'uuid text'
  db_create_table_schema(dbFile, table, schema)

  # concepts
  table = 'Concepts'
  schema = 'uuid_id text'
  db_create_table_schema(dbFile, table, schema)

  # features
  @features.each_with_index do |feature, i|
    schema = schema_of_feature(feature, @features_num[i])
    db_create_table_schema(dbFile, feature, schema)
  end
end

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
  puts sh
  %x{#{sh}}
end

@dbFile = ARGV[0]
@features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
@features_num = [256, 144, 120, 80, 192, 60, 168, 192, 64, 18]

begin
  if @dbFile == nil 
    return 
  end

  initial_database(@dbFile)
  
#  exe("./db_import_normalized.rb #{@db}")
#  exe("./db_create_views.rb #{@db}")

#  exe("./db_integrate_tables.rb #{@db}")
#  exe("./db_integrate_views.rb #{@db}")
#  exe("./db_export.rb #{@db}")

#  concept = 'c0'
#  @features.each do |feature|
#    export_concept_feature(@db, concept, feature)
#  end
end
