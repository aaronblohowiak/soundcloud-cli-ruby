require 'soundcloud'

module ScCli
  extend self
  
  def client
    @client ||= Soundcloud.new(access_token: Authentication.token)
  end

  def print_results(results, json, fields, default_field='permalink_url')
    if json
      if fields
        $stderr.puts "Ignoring fields parameter since json output was requested."
      end
      puts results.to_json
    else
      fields ||= default_field
      fields = fields.split(",")
      Array(results).each do |t|
        puts fields.map{|f| t[f]}.to_csv
      end
    end
  end

  Formatting = Proc.new do
    optional  nil, :fields, 'the fields to output as csv. Default: permalink_url'
    optional  nil, :json, 'Output the full response as json.'
  end
end

Dir[File.dirname(__FILE__)+"/sc-cli/*.rb" ].sort.each {|file| require file }
