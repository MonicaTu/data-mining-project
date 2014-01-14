#!/usr/bin/env ruby

require_relative 'parameters'
require_relative 'weka'
require_relative 'database'
require_relative 'dm_create_table_allfeatures'
require_relative 'dm_create_views_concept_feature'
require_relative 'dm_export_concept_feature'

def dm_prepare_test_set(concept_id, attributes, dbFile) 
  # create table allfeatures
  allfeatures = dm_create_table_allfeatures(dbFile, @features)

  # create table with selected attributes
  attrs = "" 
  attributes.each_with_index do |attr, i|
    attrs = (i == 0) ? "#{attr}" : "#{attrs}, #{attr}"
  end
  selectedfeatures = 'test_selectedfeatures'
  query = "SELECT #{attrs} FROM #{allfeatures}"
  db_create_table_as_schema(dbFile, selectedfeatures, query)

  # export view selectedfeatures
  csv = dm_export_concept_feature(dbFile, concept_id, selectedfeatures)
  db_drop_table(dbFile, selectedfeatures) # !!! drop table !!!

  arff = weka_csv2arff(csv)
  rm_file(csv) # !!! remove file !!!

  norm_arff = weka_normalization(arff, 'last')
  rm_file(arff) # !!! remove file !!!
  return norm_arff
end

if __FILE__ == $0
require_relative 'dm_parse_attributes'

  @dbTest = ARGV[0]

  concept_id = '0'
  train_arff = 'attribute_selection-normalized-c0_AutoColorCorrelogram_CEDD_ColorLayout_FCTH_Gabor_JCD_JpegCH_ScalableColor_Tamura.arff'
  attributes = dm_parse_attributes(train_arff)
  test_arff = dm_prepare_test_set(concept_id, attributes, @dbTest)
end
