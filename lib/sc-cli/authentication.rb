require 'highline/import'

module ScCli::Authentication
  extend self

  def token
    @token ||= begin
      token = load_from_file || acquire_token!
    end
  end

  def load_from_file
    begin
      token = File.read(File.join(ENV['HOME'], '.sc-cli'))
    rescue Errno::ENOENT
      nil
    end
  end

  def acquire_token!
    credentials = get_credentials
    client = SoundCloud.new(credentials)
    save_to_file(client.access_token)
    token
  end

  def get_credentials
    warning = <<-EXPLANATION
SoundCloud uses OAuth for authentication.
To use sc-cli, you must register an app with SoundCloud.
Register a new app here: http://soundcloud.com/you/apps

Your username and password will be sent directly to SoundCloud.
This tool will then write your access_token to $HOME/.sc-cli.

Your username and password WILL NOT be saved anywhere.

If your access_token expires, you will have to re-enter your credentials.
EXPLANATION
    puts warning.yellow

    { 
      client_id: ask("Client ID: "),
      client_secret: ask("Client Secret: "),
      username: ask("Email: "),
      password: get_password
    }
  end

  def save_to_file(token)
    File.open(File.join(ENV['HOME'], '.sc-cli'), 'w') do |f|
      f << token
    end
  end

  def get_password
    password = nil
    while password.nil? || password.length == 0
      password = ask("Password:  ") { |q| q.echo = "*" }
    end
    password
  end
end
