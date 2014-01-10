#!/usr/bin/env ruby

@maxHeap='-Xmx1024m'

def attribute_selection(input)
  output = "attribute_selection-#{File.basename(input, ".*")}.arff"

  filter = 'weka.filters.supervised.attribute.AttributeSelection' 
  search_options = '-S "weka.attributeSelection.BestFirst -D 1 -N 5"' 
  evaluator_options = '-E "weka.attributeSelection.CfsSubsetEval "' 
  sh = "java #{@maxHeap} #{filter} #{evaluator_options} #{search_options} -i #{input} -o #{output}" 
  puts sh
  %x{#{sh}}
end

# main
begin
  file = ARGV[0] 
  attribute_selection(file)
end
