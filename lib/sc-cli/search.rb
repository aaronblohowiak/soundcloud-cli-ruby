require 'csv'

module ScCli::Search
  extend self

  Options = Proc.new {
    optional  :q,  :q,   'search term'
    optional  nil, :limit, 'the number of results to return. 50 by default, max 200'
    optional  nil, :offset, 'the number of results to skip. 0 by default, max 8000'
    optional  nil, :fields, 'the fields to output as csv. Default: permalink_url'
    optional  nil, :json, 'Output the full response as json.'
    flag   :h,  :help,  'show help for this command', &ScCli::Help
  }

  def add_commands(root)
    search = root.define_command do
      name 'search'
      usage 'search [type] [options]'
      summary 'searches the Soundcloud API'

      flag   :h,  :help,  'show help for this command', &ScCli::Help
    end

    define_search_endpoint(search, 'users')
    define_search_endpoint(search, 'playlists')
    define_search_endpoint(search, 'groups')

    define_search_endpoint(search, 'tracks') do
      optional  :t,  :tags,   'comma separated list of tags'
      optional  :f,  :filter,   'One of: all,public,private,streamable,downloadable'
      optional  :l,  :license, 'One of: no-rights-reserved,all-rights-reserved,cc-by,cc-by-sa,cc-by-nd,cc-by-nc,cc-by-nc-nd'
      optional  :bf, :"bpm[from]", 'return tracks with at least this bpm value'
      optional  :bt, :"bpm[to]", 'return tracks with at least this bpm value'
      optional  :df, :"duration[from]", 'return tracks with at least this duration (in millis)'
      optional  :dt, :"duration[to]", 'return tracks with at most this duration (in millis)'
      optional  :cf, :"created_at[from]", '(yyyy-mm-dd hh:mm:ss) return tracks created at this date or later'
      optional  :ct, :"created_at[to]", '(yyyy-mm-dd hh:mm:ss) return tracks created at this date or earlier'
      optional  :i,  :ids, 'a comma separated list of track ids to filter on'
      optional  :g,  :genres, 'a comma separated list of genres'
      optional  :ty, :types, 'a comma separated list of types'
    end
  end

  def define_search_endpoint(search, endpoint, &block)
    search.define_command do
      name        endpoint
      usage       "sc search #{endpoint} [options]"
      summary     "searches for #{endpoint}"

      instance_eval &ScCli::Search::Options
      instance_eval &block if block_given?

      run &ScCli::Search.search_command('/'+endpoint)
    end
  end


  def search_command(endpoint)
    Proc.new do |opts, args|
      json = opts.delete(:json)
      fields = opts.delete(:fields)

      results = ScCli.client.get(endpoint, opts)
      print_results(results, json, fields)
    end
  end

  def print_results(results, json, fields)
    if json
      if fields
        $stderr.puts "Ignoring fields parameter since json output was requested."
      end
      puts results.to_json
    else
      fields ||= 'permalink_url'
      fields = fields.split(",")
      results.each do |t|
        puts fields.map{|f| t[f]}.to_csv
      end
    end
  end
end