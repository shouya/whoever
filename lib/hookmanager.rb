

require_relative 'whoever'


class Whoever::HookManager
  attr_reader :hook_list

  def initialize
    @hook_list = Hash.new({})
  end

  def register_hook(method, request, hook)
    @hook_list[method] = {} unless @hook_list.has_key? method
    @hook_list[method][request] = hook
  end

  def find_hook(method, req_path)
    return nil unless @hook_list.has_key? method
    found = @hook_list[method].each do |k,v|
      return v if req_path =~ k
    end
    return nil
  end


  def set_hooks
    Dir.glob(File.dirname(__FILE__) + '/hooks/*_hook.rb') do |file|
      require_relative file
    end

    register_hook(:GET, %r{/users/show\.json.*}, ::UserShowHook)
    register_hook(:GET, %r{/statuses/home_timeline\.json.*}, ::TimelineHook)
    register_hook(:GET, %r{/statuses/mentions\.json.*}, ::TimelineHook)
    register_hook(:GET, %r{/statuses/retweeted_(by|to)_me\.json.*},
                  ::TimelineHook)
    register_hook(:GET, %r{/statuses/retweets_of_me\.json.*}, ::TimelineHook)
    register_hook(:GET, %r{/statuses/user_timeline\.json.*}, ::TimelineHook)
    register_hook(:GET, %r{/statuses/retweeted_to_user\.json.*}, ::TimelineHook)
    register_hook(:GET, %r{/statuses/retweeted_by_user\.json.*}, ::TimelineHook)
  end
end
