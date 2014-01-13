#!/usr/bin/env ruby

require_relative 'parameters'
require_relative 'weka'
require_relative 'database'
require_relative 'dm_create_table_allfeatures'
require_relative 'dm_create_views_concept_feature'

def dm_prepare_test_set(concept_id, attributes, dbFile) 
  # create table allfeatures
  allfeatures = dm_create_table_allfeatures(dbFile, @features)

  # create views with selected attributes
  attrs = "" 
  attributes.each_with_index do |attr, i|
    attrs = (i == 0) ? "#{attr}" : "#{attrs}, #{attr}"
  end
  selectedfeatures = "selected_features"
  schema = "AS SELECT #{attrs} FROM #{allfeatures};"
  db_create_view_schema(dbFile, view, schema)

  # export view selectedfeatures
  csv = dm_export_concept_feature(dbFile, concept_id, selectedfeatures)
  norm_arff = weka_normalization(csv, 'last')

  return norm_arff
end
