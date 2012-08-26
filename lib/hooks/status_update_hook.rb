

require_relative '../post_hook'
require_relative '../filters/user_filter'

class StatusUpdateHook < PostHook
  def self.pre_post(param, fullpath, body, env)
    if body.key? 'status'
      body['status'][0] = UserFilter.decode_text(body['status'][0], env)
    end
  end

  def self.post_post(body, env)
    UserFilter.filter_json(body, env)
  end

end
