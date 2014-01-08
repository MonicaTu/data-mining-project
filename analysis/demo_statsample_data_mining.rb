#!/usr/bin/env ruby

require 'sqlite3'
require 'statsample'

db = SQLite3::Database.open "test.db"
stm = db.prepare "SELECT * FROM autocolorcorrelogram LIMIT 500 
rs = stm.execute 

data = Array.new(Array.new)
rs.each do |row|
  data << row
end
puts "====== data ======"
puts "#{data.length} x #{data[0].length}"
#data.each { |d| p d }

data_vectors_in_hash = Hash[ data.map {|d| ["d#{data.index(d)}", d.to_scale]} ]
#p data_vectors_in_hash

dataT = data.transpose 
puts "====== dataT ======"
puts "#{dataT.length} x #{dataT[0].length}"
#dataT.each { |d| p d }

dataT_vectors_in_hash = Hash[ dataT.map {|d| ["d#{dataT.index(d)}", d.to_scale]} ]
#p dataT_vectors_in_hash

ds = dataT_vectors_in_hash.to_dataset
#puts "====== ds ======"
#p ds

cor_matrix=Statsample::Bivariate.correlation_matrix(ds)
puts "====== cor_matrix ======"
puts "#{cor_matrix.row_size} x #{cor_matrix.column_size}"
#p cor_matrix
pca=Statsample::Factor::PCA.new(cor_matrix)
puts "====== pca ======"
#p pca
#pc = pca.principal_components(ds, nil)
#puts "====== pca.principal_components ======"
#p pc 

puts "====== pca.m ======"
p pca.m
puts "====== pca.eigenvalues ======"
#p pca.eigenvalues.length 
#p pca.eigenvalues 
#puts "====== pca.component_matrix ======"
#p pca.component_matrix 
puts "====== pca.communalities ======"
#p pca.communalities.length 
#p pca.communalities

puts "====== pca.eigenvectors ======"
puts "#{pca.eigenvectors.length} x #{pca.eigenvectors[0].length}"
p pca.eigenvectors.length
#pca.eigenvectors.each { |d| p d }

tranArray = []
pca.eigenvectors.length.times do |i|
  item = []
  pca.m.times do |j|
    item << pca.eigenvectors[i][j]
  end
  tranArray << item 
end
puts "====== tranArray ======"
puts "#{tranArray.length} x #{tranArray[0].length}"
#tranArray.each { |d| p d }

tranMatrix = Matrix.rows(tranArray)
#puts "====== tranMatrix ======"
#p tranMatrix

puts "====== new data ======"
# 1x2 = (5x256) x (256xm)
data.each_with_index do |d, i|
  new = Matrix[d]*tranMatrix
  puts "##{i}:\t#{d}\t=>\t#{new}"
end
