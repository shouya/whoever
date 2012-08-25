

require 'yaml'


require_relative 'whoever'
require_relative 'server'
require_relative 'hookmanager'


class Whoever::Main

  def initialize
    @hook_manager = Whoever::HookManager.new
    load_config
  end

  def load_config(filename = 'config.yaml')
    pathname = File.join(File.dirname(__FILE__), filename)
    $config = YAML.load_file(pathname)
  end

  def serve
    hook_manager = @hook_manager
    Whoever::Server.send(:define_method, :hook_manager) { hook_manager }
    Whoever::Server.run!
  end
end



