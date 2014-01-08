#!/usr/bin/env ruby

def rm_file(file)
  sh = "rm #{file}"
  puts sh
  %x{#{sh}}
end

def mv_csv_arff(csv_file)
  arff_file = "#{File.basename(csv_file, ".*")}.arff"
  sh = "java weka.core.converters.CSVLoader #{csv_file} > #{arff_file}" 
  puts sh
  %x{#{sh}}
  return arff_file 
end

def attribute_selection(input)
  output = "#{File.basename(input, ".*")}-attribute_selection.arff"

  filter = 'weka.filters.supervised.attribute.AttributeSelection' 
  search_options = '-S "weka.attributeSelection.BestFirst -D 1 -N 5"' 
  evaluator_options = '-E "weka.attributeSelection.CfsSubsetEval "' 
  sh = "java #{filter} #{evaluator_options} #{search_options} -i #{input} -o #{output}" 
  puts sh
  %x{#{sh}}
end

# main
begin
  csv_file = ARGV[0] 
  attribute_selection(csv_file)
#  arff_file = mv_csv_arff(csv_file)
#  attribute_selection(arff_file)
#  rm_file(arff_file)
end
