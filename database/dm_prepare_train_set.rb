#!/usr/bin/env ruby

require_relative 'parameters'
require_relative 'weka'
require_relative 'database'
require_relative 'system'
require_relative 'dm_create_table_allfeatures'
require_relative 'dm_create_views_concept_feature'
require_relative 'dm_export_concept_feature'

def dm_prepare_train_set(concept_id, attributes, dbFile) 
  # create table allfeatures
  allfeatures = dm_create_table_allfeatures(dbFile, @features)

  # create views with selected attributes
  attrs = "" 
  attributes.each_with_index do |attr, i|
    attrs = (i == 0) ? "#{attr}" : "#{attrs}, #{attr}"
  end
  selectedfeatures = "#{File.basename(dbFile, ".*")}_selectedfeatures"
  query = "SELECT #{attrs} FROM #{allfeatures}"
  db_create_table_as_schema(dbFile, selectedfeatures, query)

  # export view selectedfeatures
  csv = dm_export_concept_feature(dbFile, concept_id, selectedfeatures)
  y_num = File.open(csv).read.scan(/Y/).count
  exesh("sed -i '#{y_num*2},15001d' #{csv}") # !!! cut file !!!

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
