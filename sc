#!/usr/bin/env ruby

require './lib/sc-cli'
require 'cri'

help_proc = Proc.new do |value, cmd|
  puts cmd.help
  exit 0
end

root = Cri::Command.define do
  name        'sc'
  usage       'sc [options] [command] [options]'
  summary     'CLI for the Soundcloud API'

  flag   :h,  :help,  'show help for this command', &help_proc
end

root.define_command do
  name 'authenticate'
  usage 'authenticate'
  summary 'Authenticates you with the Soundcloud API and writes your token to ~/.sc-cli'

  flag   :h,  :help,  'show help for this command', &ScCli::Help

  run do
    token = ScCli::Authentication.acquire_token!
    puts "Authentication successful. Your token is: #{token}"
  end
end

ScCli::Search.add_commands(root)
ScCli::Playlist.add_commands(root)


unless STDOUT.tty?

  class String
    def formatted_as_title
      self
    end

    def formatted_as_command
      self
    end

    def formatted_as_option
      self
    end
  end

end

root.run(ARGV)
