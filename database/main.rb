#!/usr/bin/env ruby

db = ARGV[0]

sh = "./db_create_tables.rb #{db}"
puts sh
%x{#{sh}}
sh = "./db_import_normalized.rb #{db}"
puts sh
%x{#{sh}}
sh = "./db_create_views.rb #{db}"
puts sh
%x{#{sh}}
sh = "./db_integrate_tables.rb #{db}"
puts sh
%x{#{sh}}
sh = "./db_integrate_views.rb #{db}"
puts sh
%x{#{sh}}
sh = "./db_export.rb #{db}"
puts sh
%x{#{sh}}
