module ScCli::Playlist
  extend self

  def add_commands(root)
    playlist = root.define_command do
      name 'playlist'
      aliases :set, :p, :playlists

      usage 'playlist [action] [options]'
      summary 'uses the Soundcloud API to get and modify playlists'
    end

    playlist.define_command do
      name 'create'
      usage 'create [options]'
      summary 'creates a new playlist'
      description 'accepts track ids as a comma-separated list option or as a newline-separated list from STDIN.'
      required :t, :title, 'the title for your playlist'
      optional :s, :sharing, 'sharing options for your playlist. One of public,private.'
      optional :T, :tracks, 'comma-separated list of track ids.'
      instance_eval &ScCli::Formatting

      run do |opts, args|
        fields, json = opts.delete(:fields), opts.delete(:json)
        opts[:sharing] ||= 'public'

        ids = STDIN.tty? ? [] : STDIN.read.split("\n")
        ids += opts[:tracks].to_s.split(',')

        opts[:tracks] = ids.map{|id| {id: id}}

        result = ScCli.client.post('/playlists', :playlist => opts)

        ScCli.print_results(result, json, fields)
      end
    end

    playlist.define_command do
      name 'delete'
      usage 'delete [options]'
      summary 'deletes a playlist by id'
      description 'deletes the playlist by id.'

      required :i, :id, 'the id of the playlist to delete'

      run do |opts, args|
        puts ScCli.client.delete('/playlists/'+opts[:id]).to_json
      end
    end

    playlist.define_command do
      name 'get'
      usage 'get [options]'
      summary 'Retrieve information about a playlist'

      required :i, :id, 'the id of the playlist to delete'
      optional :r, :'sub-resource', 'the subresource to fetch. One of: users,emails,secret-token'
      instance_eval &ScCli::Formatting

      run do |opts, args|
        fields, json = opts.delete(:fields), opts.delete(:json)
        resource = opts.delete(:'sub-resource')
        additional_path = case resource
          when 'users', 'emails'
            "/shared-to/#{resource}"
          when 'secret-token'
            "/secret-token"
          when nil
            ""
          else
            raise "Unknown sub-resource"
          end

        results = ScCli.client.get('/playlists/'+opts[:id]+additional_path)
        ScCli.print_results(results, json, fields)
      end
    end
  end
end
