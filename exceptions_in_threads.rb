Thread.abort_on_exception = rand > 0.5 # Can be set to true or false

begin
  t = Thread.new do
    puts 3
    raise 'haha'
  end

  puts 1
  sleep 1
  puts 2

  t.join
rescue => e
  puts e
end
