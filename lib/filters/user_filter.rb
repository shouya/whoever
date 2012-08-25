

require_relative '../filter'

class UserFilter < Filter
  def self.filter(json, env)
    hider = env[:hider]
    json['screen_name'] = \
        hider.query_fake_value(:screen_name, json['screen_name'])
    json['name'] = \
        hider.query_fake_value(:nick_name, json['name'])
    json['description'] = \
        hider.query_fake_value(:biography, json['description'])
    # TODO: User's avatar
  end
end


