#!/usr/bin/env ruby

require_relative 'weka'
require_relative 'database'
require_relative 'system'
require_relative 'dm_create_concept_feature_views'
require_relative 'dm_export_concept_feature'
require_relative 'dm_integrate_concept_features'


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
  # views for each concept_feature
  create_concept_feature_views
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

if __FILE__ == $0
  @db = ARGV[0]
  if @db == nil 
    return 
  end

  @concept_num = 94
  @features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
  @features_num = [256, 144, 120, 80, 192, 60, 168, 192, 64, 18]
#  pca_features_num = [56, 90, 100, 58, 129, 2, 102, 22, 15, 11]

#  initial_database
#  export_concepts_and_features

  newTable = nil
  @features.each_with_index do |feature, i|
    # export data for PCA
    csv = db_export_table(@db, feature)
    arff = weka_pca(csv)
    # !!! remove file !!!
    rm_file(csv)
    csv = weka_arff2csv(arff)
    exesh("sed -i '1d' #{csv}")
 
    # import PCA results
    attr_num = File.open(arff).read.scan(/@attribute/).count
    table = "pca_#{feature}"
    schema = schema_of_feature(table, attr_num)
    db_create_table_schema(@db, table, schema)
    db_import_csv(@db, table, csv)

    # !!! remove files !!!
    rm_file(arff)
    rm_file(csv)

    # integrate all features
    if i == 0
      newTable = table
    else
      left = newTable
      newTable = db_combine_tables(@db, left, table) 
      if i > 1
        # !!! remove files !!!
        db_drop_table(@db, left)
      end
    end
  end 

  # integrate concept x all features
#  @concept_num.times do |i|
    i = 0
    tables = dm_integrate_concept_features(@db, i, newTable) # concept x yes/no x feature views
    concept = "c#{i}"
    csv = dm_export_concept_feature(@db, concept, newTable)

    # feature selection
    weka_attribute_selection(csv)
#  end
end
