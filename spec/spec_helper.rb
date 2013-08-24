ROOT = File.join(File.dirname(__FILE__),  "../")

Dir[ROOT + "/lib/**/*.rb", ROOT + "/lib/*.rb" ].each {|file| require file }

def fixture_path(path)
  File.join(ROOT, 'spec', 'fixtures', path)
end

