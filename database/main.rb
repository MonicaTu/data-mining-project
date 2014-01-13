#!/usr/bin/env ruby

require_relative 'weka'
require_relative 'database'
require_relative 'system'
require_relative 'parameters'
require_relative 'dm_create_views_concept_feature'
require_relative 'dm_export_concept_feature'
require_relative 'dm_create_table_allfeatures'
require_relative 'dm_parse_attributes'
require_relative 'dm_prepare_train_set'
require_relative 'dm_prepare_test_set'

def initial_database
  db_create_database(@dbTrain)
  # uuid
  table = 'UUID'
  schema = 'id integer, uuid text'
  db_create_table_schema(@dbTrain, table, schema)

  # concepts
  table = 'Concepts'
  schema = 'id integer, uuid_id text'
  db_create_table_schema(@dbTrain, table, schema)

  # features
  @features.each_with_index do |feature, i|
    schema = schema_of_feature(feature, @features_num[i])
    db_create_table_schema(@dbTrain, feature, schema)
  end

  # import data
  import_concepts_and_features
end

def dimensionality_reduction
  @features.each_with_index do |feature, i|
    table = "pca_#{feature}"

    if db_is_table_created(@dbTrain, table) && db_is_imported(@dbTrain, table)
      next
    end

    # export feature data
    csv = db_export_table(@dbTrain, feature)
    # pca
    pca_arff = weka_pca(csv)
    rm_file(csv) # !!! remove file !!!
    attr_num = File.open(pca_arff).read.scan(/@attribute/).count
    # pca - normalization 
    norm_arff = weka_normalization(pca_arff, 'last')
    rm_file(pca_arff) # !!! remove file !!!
    # pca - arff2csv
    pca_csv = weka_arff2csv(norm_arff)
    rm_file(norm_arff) # !!! remove file !!!
    exesh("sed -i '1d' #{pca_csv}")
 
    # create PCA tables
    schema = schema_of_feature(table, attr_num)
    db_create_table_schema(@dbTrain, table, schema)

    # import PCA results
    if db_is_imported(@dbTrain, table) == false
      db_import_csv(@dbTrain, table, pca_csv)
    end
      rm_file(pca_csv)  # !!! remove file !!!
  end 
end

def data_mining(concept_id)
  # create table allfeatures
#  allfeatures = dm_create_table_allfeatures(@dbTrain, @features)

  # export view allfeatures
#  csv = dm_export_concept_feature(@dbTrain, concept_id, allfeatures)

  # feature selection w/ concept_allfeatures
  # TODO: limit N-num = Y-num
#  norm_arff = weka_normalization(csv, 'last')
#  rm_file(csv) # !!! remove file !!!
#  attr_arff = weka_attribute_selection(norm_arff, 'last')
#  rm_file(norm_arff) # !!! remove file !!!

attr_arff = 'attribute_selection-normalized-c0_AutoColorCorrelogram_CEDD_ColorLayout_FCTH_Gabor_JCD_JpegCH_ScalableColor_Tamura.arff'
  # prepare test set
  attributes = dm_parse_attributes(attr_arff)
  train_arff = dm_prepare_train_set(concept_id, attributes, @dbTrain)
  test_arff = dm_prepare_test_set(concept_id, attributes, @dbTest)

  # classify
  # TODO: limit N-num = Y-num
  weka_classify(train_arff, 'last', test_arff)
  rm_file(train_arff) # !!! remove file !!!
  rm_file(test_arff) # !!! remove file !!!

  # !!! drop views !!!
  # TODO: delete it! 
#  views.each do |view|
#    db_drop_view(@dbTrain, view) 
#  end
end

#====================================

def import_concepts_and_features
  db_import_csv(@dbTrain, 'UUID', '../train_id.csv')
  db_import_csv(@dbTrain, 'Concepts', '../concepts/concepts.csv')
  
  @features.each do |feature|
    csv = "../../Train/train_features/ImageCLEF 2012 (training) - #{feature}.csv" 
    db_import_csv(@dbTrain, feature, csv)
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

if __FILE__ == $0
  @dbTrain = ARGV[0]
  @dbTest = ARGV[1]
  if @dbTrain == nil || @dbTest == nil 
    return 
  end

  initial_database
  data_mining(0)
#  dimensionality_reduction
#  @concept_num.times do |i|
#    data_mining(i)
#  end
end
