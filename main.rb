require_relative "lib/yms"
require "yaml"
require "bundler"
Bundler.require

options = Slop.parse do
  banner "Usage: ruby main.rb [options]"

  on "c", "config=", "Config file path"
  on      "init",    "Initialize"
end

unless options.config?
  $stderr.puts "Please set config file path"
  $stderr.puts options
  exit
end

YMS.cache_dir = File.join(__dir__, "cache")

YMS.run(
  init:   options.init?,
  name:   File.basename(options[:config], ".yml"),
  config: YAML.load_file(options[:config])
)
