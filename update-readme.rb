require 'erb'

root = File.dirname(__FILE__)

template = ERB.new File.new(root+"/README.md.erb").read, nil, "%"
File.write("README.md", template.result(binding))
