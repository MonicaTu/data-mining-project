#!/usr/bin/env ruby

@maxHeap='-Xmx1024m'

def export_table(db, table, yn)
  sh = "" # sh: shell script
  if yn == 1
    sh = "sqlite3 #{db} <<!
.mode csv
.headers on
.output #{table}.csv 
SELECT 'Y', * FROM #{table};
!"
  else
    sh = "sqlite3 #{db} <<!
.mode csv
.output #{table}.csv 
SELECT 'N', * FROM #{table};
!"
  end

  %x{#{sh}}
end

def rm_file(file)
  sh = "rm #{file}"
  %x{#{sh}}
end

def combine_and_rm_2files(output, file1, file2)
  sh = "cat #{file1} #{file2} >> #{output}"
  %x{#{sh}}
  rm_file(file1)
  rm_file(file2)
end

def mv_csv_arff(csv_file)
  arff_file = "#{File.basename(csv_file, ".*")}.arff"
  sh = "java #{@maxHeap} weka.core.converters.CSVLoader #{csv_file} > #{arff_file}" 
  %x{#{sh}}
  rm_file(csv_file)
  return arff_file 
end

def generate_concept_feature(concept, feature)
  db = 'train.db'
  format = 'csv'

  table_yes = "#{concept}_yes_#{feature}"
  table_no = "#{concept}_no_#{feature}"
  output = "#{concept}_#{feature}.#{format}"

  export_table(db, table_yes, 1)
  export_table(db, table_no, 0)

  file_yes = "#{table_yes}.#{format}"
  file_no = "#{table_no}.#{format}"
  combine_and_rm_2files(output, file_yes, file_no)
  return mv_csv_arff(output)
end

def attribute_selection(input)
  output = "#{File.basename(input, ".*")}-attribute_selection.arff"

  filter = 'weka.filters.supervised.attribute.AttributeSelection' 
  search_options = '-S "weka.attributeSelection.BestFirst -D 1 -N 5"' 
  evaluator_options = '-E "weka.attributeSelection.CfsSubsetEval "' 
  sh = "java #{@maxHeap} #{filter} #{evaluator_options} #{search_options} -i #{input} -o #{output}" 
  %x{#{sh}}
end

# main
concept = 'c0'
features = ["autocolorcorrelogram", "cedd", "colorlayout", "edgehistogram", "fcth", "gabor", "jcd", "jpegch", "scalablecolor", "tamura"]
features.each do |feature|
  file = generate_concept_feature(concept, feature)
  attribute_selection(file)
  rm_file(file)
end
