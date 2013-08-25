require 'set'

module ScCli::Track
  extend self

  def add_commands(root)
    track = root.define_command do
      name 'track'
      aliases :t, :tracks

      usage 'track [action] [options]'
      summary 'uses the Soundcloud API to get and modify tracks'
    end

    track.define_command do
      name 'upload'
      usage 'upload [options] filename1 filename2 ... filename N'
      description 'Uploads files to Soundcloud, accepting filenames as ending args or as a newline-delimited list via STDIN.'

      optional :t, :title, 'the Title for the track. Not used if multiple filenames are provided.'
      optional :s, :sharing, 'public/private sharing. One of: public,private'

      instance_eval &ScCli::Formatting

      run do |opts, args|
        json = opts.delete(:json)
        fields = opts.delete(:fields)
        filenames = Array(args)
        filenames += STDIN.tty? ? [] : STDIN.read.split("\n")
        valid = filenames.select do |filename|
          VALID_TYPES.include? File.extname(filename)
        end

        $stderr.puts "Not uploading files with invalid names: " + (filenames - valid).inspect.red

        if valid.length > 1 && opts[:title]
          $stderr.puts "Ignoring track title since multiple filenames were provided.".red
          opts[:title] = nil
        end

        valid.each do |filename|
          result = ScCli.client.post('/tracks', :track => {
            :title => opts[:title] || ScCli::Track.title_from_filename(filename),
            :asset_data => File.open(filename, 'rb'),
            :sharing => opts[:sharing] || 'public'
          })

          ScCli.print_results(result, json, fields)
        end

      end
    end
  end

  def title_from_filename(filename)
    ext = File.extname(filename)
    File.basename(filename, ext)
  end


  VALID_TYPES = Set.new(%w{
    .aac
    .aiff
    .amr
    .flac
    .mp2
    .mp3
    .ogg
    .wav
    .wave
    .wma
  })
end
