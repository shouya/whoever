# -*- coding: utf-8 -*-

require_relative '../get_hook'

require_relative '../filters/user_filter'

class UserShowHook < GetHook
  def self.pre_get(param, fullpath, env)
    UserFilter.decode_parameter(param, env)
  end

  def self.post_get(body, env)
    UserFilter.filter_user(body, env)
  end

end
