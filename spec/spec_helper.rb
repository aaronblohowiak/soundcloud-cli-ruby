ROOT = File.join(File.dirname(__FILE__),  "../")

require ROOT+'lib/sc-cli.rb'
include ScCli

def fixture_path(path)
  File.join(ROOT, 'spec', 'fixtures', path)
end

