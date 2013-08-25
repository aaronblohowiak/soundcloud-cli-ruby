$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))

Gem::Specification.new do |s|
  s.name        = 'sc'
  s.version     = "0.0.1"
  s.homepage    = 'https://github.com/aaronblohowiak/soundcloud-cli-ruby/'
  s.summary     = 'a library for interacting with SoundCloud from the command line'
  s.description = 'sc easily allows you to manipulate your SoundCloud content from the cli'

  s.author = 'Aaron Blohowiak'
  s.email  = 'aaron.blohowiak@gmail.com'

  s.files              = Dir['[A-Z]*'] +
                         Dir['{lib}/**/*'] +
                         [ 'sc.gemspec']

  s.require_paths      = [ 'lib' ]

  s.executables << 'sc'

  s.add_dependency('soundcloud', '>= 0.3.2')
  s.add_dependency('cri', '>= 2.3.0')
  s.add_dependency('highline', '>= 1.6.19')

  s.add_development_dependency('rspec')

  s.rdoc_options     = [ '--main', 'README.md' ]
  s.extra_rdoc_files = [ 'LICENSE', 'README.md']
end

