#!/usr/bin/env ruby

@maxHeap='-Xmx4096m'

def weka_pca(input)
  output = "pca-#{File.basename(input, ".*")}.arff"
  filter = 'weka.filters.unsupervised.attribute.PrincipalComponents -R 0.95 -A 5 -M -1'
  exe("java #{@maxHeap} #{filter} -i #{input} -o #{output}") 
  return output
end

def weka_attribute_selection(input)
  output = "attribute_selection-#{File.basename(input, ".*")}.arff"
  filter = 'weka.filters.supervised.attribute.AttributeSelection' 
  search_options = '-S "weka.attributeSelection.BestFirst -D 1 -N 5"' 
  evaluator_options = '-E "weka.attributeSelection.CfsSubsetEval "' 
  exe("java #{@maxHeap} #{filter} #{evaluator_options} #{search_options} -i #{input} -o #{output}") 
  return output
end

def weka_normalization(input)
  output = "normalized-#{File.basename(input, ".*")}.arff"
  filter = 'weka.filters.unsupervised.attribute.Normalize'
  options = '-S 1.0 -T 0.0'
  exe("java #{@maxHeap} #{filter} #{options} -i #{input} -o #{output}") 
  return output
end

def weka_csv2arff(csv)
  arff = "#{File.basename(csv, ".*")}.arff"
  exe("java #{@maxHeap} weka.core.converters.CSVLoader -i #{csv} -o #{arff}") 
  return arff
end

def weka_arff2csv(arff)
  csv = "#{File.basename(arff, ".*")}.csv"
  path = File.dirname(arff)
  exe("java #{@maxHeap} weka.core.converters.CSVSaver -i #{arff} -o #{path}/#{csv}")
  return csv
end

def exe(sh)
  puts sh
  %x{#{sh}}
end

# main
if __FILE__ == $0
  input = ARGV[0] 
  weka_attribute_selection(input)
end

