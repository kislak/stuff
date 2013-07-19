#!/usr/bin/env ruby

require 'daemons'
Daemons.daemonize

SPRINT = 25 * 60
REST = 5 * 60

SLEEP_INTERVAL = 5

# HIDE_CMD = 'kill all $(pidof gmessage)'

GMESSAGE = "gmessage -center -nofocus -font 'Sans Bold 24'"
START_MSG = "#{GMESSAGE} 'GO GO GO!'"
STOP_MSG = "#{GMESSAGE} 'Machen Sie eine Pause'"
GOOD_JOB_MSG = "#{GMESSAGE} 'Good Job!'"

number_of_sprints = (ARGV[0] && ARGV[0].to_i || 2)

start = Time.now
status = :work
counter = 0
`#{START_MSG}`

loop do
  if status == :work && (Time.now - start) >= SPRINT
    status = :rest
    start = Time.now
    counter += 1
    counter < number_of_sprints ? `#{STOP_MSG}` : `#{GOOD_JOB_MSG}`
  end

  if status == :rest && (Time.now - start) >= REST
    status = :work
    start = Time.now
    `#{START_MSG}`
  end 
  
  exit 0 if counter >= number_of_sprints
  sleep SLEEP_INTERVAL
end
