require 'timeout'
begin
  Timeout.timeout(3){`/usr/bin/wbinfo -P`}
rescue Timeout::Error
  `/etc/init.d/winbind restart`
end
