class EventLog
  LOG_PATH = '/var/log'

  SECONDS_IN_DAY = 60 * 60 * 24
  HEADER = [
        'Type',
        'Date',
        'Time',
        'Host IP address',
        'Administrator',
        'Description'
  ]

  private
  
  def self.current_log_file
    last = last_log_file_by_date
    if last.empty?
      file_name = "#{LOG_PATH}/#{Time.now.strftime('%Y-%m-%d')}_EventLog.csv"
      create_log(file_name)
      return file_name
    end

    time_to_create = Time.now - (SECONDS_IN_DAY * Time.now.wday)
    file_time = Time.new(*last.split('_').first.split('-'))

    if time_to_create > file_time
      file_name = "#{LOG_PATH}/#{time_to_create.strftime('%Y-%m-%d')}_EventLog.csv"
      create_log(file_name)
      return file_name
    end

    "#{LOG_PATH}/#{last}"
  end

  def self.create_log(file_name)
    `mkdir #{LOG_PATH}` unless Dir.exists?(LOG_PATH)
    unless File.exists?(file_name)
      `echo #{HEADER.join(',')} > #{file_name}`
      add_byte_order_mark(file_name)
    end
  end

  def self.add_byte_order_mark(file_name)
    command = ['sed', '-i', '1s/^/\xef\xbb\xbf/', file_name]
    logger.trace_method_debug(self, 'invoking external command: ' + command.join(' '))
    unless system(*command)
      logger.trace_method_error(self, "raised error: #{$?}")
    end
    return $?.exitstatus
  end

  def self.last_log_file_by_date
    `ls #{LOG_PATH} -t -r | tail -n 1`.strip
  end

  def self.store(name, action, user, params)
    handler = "#{name}_#{action}_note".to_sym

    if EventLogHandler.respond_to?(handler)
      description = EventLogHandler.send(handler, params)
    elsif SystemEventLogHandler.respond_to?(handler)
      description, type = SystemEventLogHandler.send(handler, params)
    end

    if description
      type ||= 'Info'
      t = Time.now
      date = t.strftime('%Y-%m-%d')
      time = t.strftime('%H:%M:%S')
      ip = params && params[:_ip] || '127.0.0.1'
      user = (user && user.login) || 'System'

      [description].flatten.each do |d|
        record = [type, date, time, ip, user, d].to_csv.strip.gsub(/\0/, '')
        record = Shellwords.escape(record).gsub("/", "\\/")
        system('sed', "-i", "-e" "1s/$/\\n#{record}/".untaint, current_log_file.untaint)
      end
    end
  end
end

