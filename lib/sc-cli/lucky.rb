module ScCli::Lucky
  extend self

  def add_commands(root)
    root.define_command do
      name 'lucky'
      usage 'lucky [options] [search term]'
      summary 'picks a track at random and plays it using the `open` command.'

      instance_eval &ScCli::Search::TrackOptions

      run do |opts, args|
        opts[:q] = args.join(" ") if args && args.length > 0

        opts.merge(:limit => 1, :offset => rand(20))
        result = ScCli.client.get('/tracks', opts).first

        url = result['stream_url'] + "?oauth_token=#{ScCli::Authentication.token}"
        puts "Streaming #{url}"
        puts "Permalink: #{result['permalink_url']}"

        `open #{url}`
        `open #{result['permalink_url']}`
      end
    end
  end
end
