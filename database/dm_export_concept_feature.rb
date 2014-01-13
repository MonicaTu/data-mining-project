#!/usr/bin/env ruby

require_relative 'system'

def export_table(dbFile, table, yn)
  sh = "" # sh: shell script
  if yn == 1
    sh = "sqlite3 #{dbFile} <<!
.mode csv
.headers on
.output #{table}.csv 
SELECT *, 'Y' FROM #{table};
!"
  else
    sh = "sqlite3 #{dbFile} <<!
.mode csv
.output #{table}.csv 
SELECT *, 'N' FROM #{table};
!"
  end

  puts sh
  %x{#{sh}}
end

def combine_and_rm_2files(output, file1, file2)
  sh = "cat #{file1} #{file2} >> #{output}"
  puts sh
  %x{#{sh}}
  rm_file(file1)
  rm_file(file2)
end

def dm_export_concept_feature(dbFile, concept_id, feature)
  format = 'csv'

  # create 2 views, yes & no
  views = dm_create_views_concept_feature_yes_and_no(dbFile, concept_id, feature) 

  # export yes
  table_yes = "#{views[0]}_#{feature}"
  file_yes = "#{table_yes}.#{format}"
  export_table(dbFile, table_yes, 1)

  # export no
  table_no = "#{views[1]}_#{feature}"
  file_no = "#{table_no}.#{format}"
  export_table(dbFile, table_no, 0)

  # save to file, yes_no
  output = "c#{concept_id}_#{feature}.#{format}"
  combine_and_rm_2files(output, file_yes, file_no)
  return output
end

# main
if __FILE__ == $0
  dbFile = ARGV[0] 
  concept_id = ARGV[1] 
  feature = ARGV[2] 
#  feature = 'autocolorcorrelogram_cedd_colorlayout_edgehistogram_fcth_gabor_jcd_jpegch_scalablecolor_tamura'
  csv_file = dm_export_concept_feature(dbFile, concept_id, feature)
  puts csv_file
end
