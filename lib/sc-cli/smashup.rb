module ScCli::Smashup
  extend self

  def add_commands(root)
    root.define_command do
      name 'smashup'
      usage 'smashup [options] search terms'
      summary 'plays tracks from different genres simultaneously.  Like a mashup, but with more smash!'

      instance_eval &ScCli::Search::TrackOptions

      optional :g, :genres, 'comma-separated list of genres to smash!'

      run do |opts, args|
        opts[:q] = args.join(" ") if args && args.length > 0

        opts.merge!(
          :limit => 1,
          :offset => rand(20),
          :'duration[from]' => 120 * 100
        )

        genres = opts.delete(:genres) || 'storytelling,classical'
        genres = genres.split(',')

        genres.map do |genre|
          opts.merge!(:genres => genre)
          ScCli.client.get('/tracks', opts).first
        end.map do |result|
          `open #{result['stream_url']}?oauth_token=#{ScCli::Authentication.token}`
          puts "Playing #{result['permalink_url']}"
        end
      end
    end
  end
end
