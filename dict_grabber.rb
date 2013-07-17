require 'open-uri'
base_address = 'http://dict.mova.org/dicts'
destination = '/media/storage/laboratory/dict'

lines = open(base_address).readlines

lines = lines.map{|l| l =~ /href="(.*?)"/ &&  $1} - ['', nil, '../']

lines.each do |file|
  `cd #{destination} && wget #{base_address}/#{file}`
  puts "file"
end

puts 'done'
