require 'soundcloud'

module ScCli
  extend self
  
  def client
    @client ||= Soundcloud.new(access_token: Authentication.token)
  end

  Help = Proc.new do |value, cmd|
    puts cmd.help
    exit 0
  end
end

Dir[File.dirname(__FILE__)+"/sc-cli/*.rb" ].sort.each {|file| require file }
