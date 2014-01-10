#!/usr/bin/env ruby

@maxHeap='-Xmx1024m'

def normalization(input, output)
  filter = 'weka.filters.unsupervised.attribute.Normalize'
  options = '-S 1.0 -T 0.0'
  sh = "java #{@maxHeap} #{filter} #{options} -i #{input} -o #{output}" 
  puts sh
  %x{#{sh}}
end

def rm_file(file)
  sh = "rm #{file}"
  puts sh
  %x{#{sh}}
end

def arff2csv(arff)
  csv = "#{File.basename(arff, ".*")}.csv"
  path = File.dirname(arff)
  sh = "java #{@maxHeap} weka.core.converters.CSVSaver -i #{arff} -o #{path}/#{csv}"
  puts sh
  %x{#{sh}}
  return csv
end

def csv2arff(csv)
  arff = "#{File.basename(csv, ".*")}.arff"
  sh = "java #{@maxHeap} weka.core.converters.CSVLoader -i #{csv} -o #{arff}" 
  puts sh
  %x{#{sh}}
  return arff
end

# main
@features = ['AutoColorCorrelogram', 'CEDD', 'ColorLayout', 'EdgeHistogram', 'FCTH', 'Gabor', 'JCD', 'JpegCH', 'ScalableColor', 'Tamura']
begin
  inputPath = ARGV[0] 
  outputPath = ARGV[1] 
  @features.each do |f| 
    input = "#{inputPath}/#{f}.csv"
    output = "#{outputPath}/normalized-#{f}.arff"
    normalization(input, output)
    arff2csv(output)
    rm_file(output)
  end
end
