#!/usr/bin/env ruby

# shell script
def exesh(sh)
  puts sh
  %x{#{sh}}
end

def rm_file(file)
  puts "---------!!!!--------"
  exesh("rm #{file}")
end

def write_file(output, text)
  File.open(output, 'w') { |file| file.write(text) }
end

