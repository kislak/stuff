puts 'Thread.abort_on_exception(default) = ' + Thread.abort_on_exception.to_s

Thread.abort_on_exception = rand > 0.5 # Can be set to true or false
puts 'Thread.abort_on_exception = ' + Thread.abort_on_exception.to_s

begin
  t = Thread.new do
    puts 3
    raise 'haha'
  end

  puts 1
  sleep 5
  puts 2

  t.join
rescue => e
  puts e
end
