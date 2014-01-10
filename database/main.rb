#!/usr/bin/env ruby

require_relative 'database'
require_relative 'db_create_views'

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
end

def import_concepts_and_features
  db_import_csv(@db, 'UUID', '../train_id.csv')
  db_import_csv(@db, 'Concepts', '../concepts/concepts.csv')
  
  @features.each do |feature|
    csv = "../../Train/train_features/ImageCLEF 2012 (training) - #{feature}.csv" 
    db_import_csv(@db, feature, csv)
  end
end

def export_concepts_and_features
  @concept_num.times do |i|
    concept = "c#{i}"
    @features.each do |feature|
      export_concept_feature(concept, feature)
    end
  end
end

#====================================

def export_concept_feature(concept, feature)
  format = 'csv'

  table_yes = "#{concept}_yes_#{feature}"
  table_no = "#{concept}_no_#{feature}"
  output = "#{concept}_#{feature}.#{format}"

  db_export_table(@db, table_yes)
  db_export_table(@db, table_no)

  file_yes = "#{table_yes}.#{format}"
  file_no = "#{table_no}.#{format}"
  combine_and_rm_2files(output, file_yes, file_no)
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

def combine_and_rm_2files(output, file1, file2)
  exe("cat #{file1} #{file2} >> #{output}")
  rm_file(file1)
  rm_file(file2)
end

def rm_file(file)
  exe("rm #{file}")
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

  initial_database
  import_concepts_and_features
  create_concept_feature_views(@db, @concept_num, @features.count)
  export_concepts_and_features
  
#  exe("./db_import_normalized.rb #{@db}")
#  exe("./db_create_views.rb #{@db}")

#  exe("./db_integrate_tables.rb #{@db}")
#  exe("./db_integrate_views.rb #{@db}")
#  exe("./db_export.rb #{@db}")
end
