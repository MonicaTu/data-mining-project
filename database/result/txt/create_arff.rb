#!/usr/bin/env ruby

class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

#"blahblahblahSTARTfoofoofooENDwowowowowo".string_between_markers("START", "END")

if __FILE__ == $0
 94.times do |i|
   input = "c#{i}_train_selectedfeatures-normalized-selectedattribues.txt"
   output = "#{File.basename(input, ".*")}.arff"
   contents = File.read(input)
   attrs = contents.split
 
   f = File.new(output, 'w+') 
   attrs.each do |attr|
     text =  "@attribute #{attr.string_between_markers("\"", "\"")} numeric\n"
     f.write(text) 
   end
   f.close
 end
end
