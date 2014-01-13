#!/usr/bin/env ruby

def dm_parse_attributes(arff)
  attributes = []
  File.readlines(arff).each do |line|
    if line.scan(/numeric/).count != 0
      attributes << line.split[1]
    end
  end
  return attributes
end


if __FILE__ == $0
  arff = ARGV[0]
  attributes = dm_parse_attributes(arff)
  p attributes
end
