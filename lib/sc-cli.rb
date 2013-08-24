require 'soundcloud'

Dir[File.dirname(__FILE__)+"/sc-cli/*.rb" ].sort.each {|file| require file }

$client = Soundcloud.new(access_token: Authentication.token)

