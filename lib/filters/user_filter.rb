
require 'json'

require_relative '../hider'

class UserFilter
  USER_REGEXP = /@[a-zA-Z_]+/

  def self.filter_user(json, env)
    hider = env[:hider]
    json['screen_name'] = \
        hider.query_fake_value(:screen_name, json['screen_name'])
    json['name'] = \
    hider.query_fake_value(:nick_name, json['name'])

    if json.key? 'description'
      json['description'] = \
          hider.query_fake_value(:biography, json['description'])
    end

    if json.key? 'status'
      filter_json(json['status'], env)
    end

    avatar_url = $config['dynamic_avatar'] % json['screen_name']

    json['profile_image_url'] = avatar_url if json.key? 'profile_image_url'
    json['profile_image_url_https'] = avatar_url if
      json.key? 'profile_image_url_https'

  end
  class << self
    alias_method :filter, :filter_user
  end

  def self.filter_json(json, env)
    hider = env[:hider]

    if json.is_a? Array
      json.each do |x|
        filter_json(x, env)
      end
      return
    end

    filter_entities(json['entities'], env) if json.key? 'entities'
    json['text'] = filter_text(json['text'], env) if json.key? 'text'
    filter_user(json['user'], env) if json.key? 'user'
    if json['in_reply_to_screen_name']
      json['in_reply_to_screen_name'] = \
          hider.query_fake_value(:screen_name, json['in_reply_to_screen_name'])
    end
    if json.key? 'retweeted_status'
      filter_json(json['retweeted_status'], env)
    end

  end

  def self.filter_text(text, env)
    text.gsub(USER_REGEXP) do |x|
      '@' + env[:hider].query_fake_value(:screen_name, x[1..-1])
    end
  end
  def self.decode_text(text, env)
    text.gsub(USER_REGEXP) do |x|
      '@' + env[:hider].query_real_value(:screen_name, x[1..-1])
    end
  end

  def self.filter_entities(json, env)
    return nil unless json.key? 'user_mentions'

    json['user_mentions'].each { |x| filter_user(x, env) }
  end
  def self.filter_user_list(json, env)
    json.each do |x|
      filter_user(x, env)
    end
  end

  def self.decode_parameter(param, env)
    if param.has_key? 'screen_name'
      puts "DECODING SCREENNAME: #{param['screen_name'][0].inspect}"
      param['screen_name'][0] = \
        env[:hider].query_real_value(:screen_name, param['screen_name'][0])
      puts "INTO: #{param['screen_name'][0].inspect}"
    end
  end
end


