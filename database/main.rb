#!/usr/bin/env ruby

require_relative 'weka'
require_relative 'database'
require_relative 'system'
require_relative 'dm_create_views_concept_feature'
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

def dimensionality_reduction
  @features.each_with_index do |feature, i|
    table = "pca_#{feature}"

    # check whether pca data was already imported or not. 
    if db_is_imported(@db, table)
      next
    end

    # export data for PCA
    csv = db_export_table(@db, feature)
    arff = weka_pca(csv)
    rm_file(csv) # !!! remove file !!!
    csv = weka_arff2csv(arff)
    exesh("sed -i '1d' #{csv}")
 
    # import PCA results
    attr_num = File.open(arff).read.scan(/@attribute/).count
    schema = schema_of_feature(table, attr_num)
    db_create_table_schema(@db, table, schema)
    db_import_csv(@db, table, csv)

    rm_file(arff) # !!! remove file !!!
    rm_file(csv)  # !!! remove file !!!
  end 
end

def data_mining(concept_id)
  views = []

  # 'yes/no' views for each concept_feature
  @features.each do |feature|
    yn = dm_create_views_concept_feature_yes_and_no(@db, concept_id, feature)
    yn.each { |view| views << view }
  end

  # create table allfeatures
  allfeatures = create_table_allfeatures

  # create 'yes/no' views for concept_allfeatures
  yn = dm_create_views_concept_feature_yes_and_no(@db, concept_id, allfeatures) 
  yn.each { |view| views << view }

  # export view allfeatures
  csv = dm_export_concept_feature(@db, concept_id, allfeatures)

  # feature selection w/ concept_allfeatures
  arff = weka_attribute_selection(csv, 'first')
  rm_file(csv) # !!! remove file !!!

  # classify
  weka_classify(arff, 'last')
  rm_file(arff) # !!! remove file !!!

  # !!! drop views !!!
  views.each do |view|
    db_drop_view(@db, view) 
  end
end

#====================================

def import_concepts_and_features
  db_import_csv(@db, 'UUID', '../train_id.csv')
  db_import_csv(@db, 'Concepts', '../concepts/concepts.csv')
  
  @features.each do |feature|
    csv = "../../Train/train_features/ImageCLEF 2012 (training) - #{feature}.csv" 
    db_import_csv(@db, feature, csv)
  end
end

def create_table_allfeatures
  allfeatures = nil
  @features.each_with_index do |feature, i|
    table = "pca_#{feature}"
    # integrate all features
    if i == 0
      allfeatures = table
    else
      left = allfeatures
      allfeatures = db_combine_tables(@db, left, table) 
#      if i > 1
#        db_drop_table(@db, left) # !!! drop table !!!
#      end
    end
  end 
  return allfeatures
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

if __FILE__ == $0
  @db = ARGV[0]
  if @db == nil 
    return 
  end

  @concept_num = 94
  @features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
  @features_num = [256, 144, 120, 80, 192, 60, 168, 192, 64, 18]

  initial_database
  dimensionality_reduction
  @concept_num.times do |i|
    data_mining(i)
  end
end
