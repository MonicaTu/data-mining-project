#!/usr/bin/env ruby

def rm_file(file)
  sh = "rm #{file}"
  puts sh
  %x{#{sh}}
end

def csv2arff(csv)
  arff = "#{File.basename(csv, ".*")}.arff"
  sh = "java -Xmx128m weka.core.converters.CSVLoader #{csv} > #{arff}" 
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
