#!/usr/bin/env ruby

require './lib/sc-cli'
require 'cri'

help_proc = Proc.new do |value, cmd|
  puts cmd.help
  exit 0
end

super_cmd = Cri::Command.define do
  name        'sc'
  usage       'sc [options] [command] [options]'
  summary     'CLI for the Soundcloud API'

  flag   :h,  :help,  'show help for this command', &help_proc
end

super_cmd.define_command do
  name 'authenticate'
  usage 'authenticate'
  summary 'Authenticates you with the Soundcloud API and writes your token to ~/.sc-cli'

  flag   :h,  :help,  'show help for this command', &ScCli::Help

  run do
    token = ScCli::Authentication.acquire_token!
    puts "Authentication successful. Your token is: #{token}"
  end
end

ScCli::Search.add_commands(super_cmd)

super_cmd.run(ARGV)
