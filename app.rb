


require 'sinatra'

require_relative 'lib/main'

whoever = Whoever::Main.new
whoever.load_config
whoever.set_hooks

whoever.serve



