# -*- coding: utf-8 -*-

require_relative '../get_hook'

require_relative '../filters/user_filter'

class UserShowHook < GetHook
  def self.pre_get(param, fullpath, env)
    if param.has_key? 'screen_name'
      param['screen_name'][0] = \
        env[:hider].query_real_value(:screen_name, param['screen_name'][0])
    end
  end

  def self.post_get(body, env)
    UserFilter.filter(body, env)
  end

end
