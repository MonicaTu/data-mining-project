#/usr/bin/env ruby

def dm_create_table_allfeatures(dbFile, features)
  allfeatures = nil
  features.each_with_index do |feature, i|
    table = "#{feature}"
    # integrate all features
    if i == 0
      allfeatures = table
    else
      left = allfeatures
      allfeatures = db_combine_tables(dbFile, left, table) 
#      if i > 1
#        db_drop_table(dbFile, left) # !!! drop table !!!
#      end
    end
  end 
  return allfeatures
end
