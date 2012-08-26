# -*- coding: utf-8 -*-

require_relative '../get_hook'

require_relative '../filters/user_filter'

class FriendshipShowHook < GetHook
  def self.pre_get(param, fullpath, env)
    if param.has_key? 'target_screen_name'
      param['target_screen_name'][0] =
        env[:hider].query_real_value(:screen_name,
                                     param['target_screen_name'][0])
    end
    if param.has_key? 'source_screen_name'
      param['source_screen_name'][0] =
        env[:hider].query_real_value(:screen_name,
                                     param['source_screen_name'][0])
    end
  end

  def self.post_get(body, env)
    UserFilter.filter_user(body, env)
  end

end
