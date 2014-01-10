#!/usr/bin/env ruby

@maxHeap='-Xmx1024m'

def rm_file(file)
  sh = "rm #{file}"
  puts sh
  %x{#{sh}}
end

def csv2arff(csv)
  arff = "#{File.basename(csv, ".*")}.arff"
  sh = "java #{@maxHeap} weka.core.converters.CSVLoader -i #{csv} -o #{arff}" 
  puts sh
  %x{#{sh}}
  return arff
end

# main
begin
  csv = ARGV[0] 
  arff = csv2arff(csv)
#  rm_file(arff)
end
