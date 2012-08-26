

require_relative '../get_hook'

require_relative '../filters/user_filter'

class TimelineHook < GetHook
  def self.pre_get(param, _, env)
    UserFilter.decode_parameter(param, env)
  end
  def self.post_get(body, env)
    UserFilter.filter_json(body, env)
  end
end

