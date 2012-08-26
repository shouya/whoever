

require_relative 'hook'

class PostHook < Hook
  # Filter Request Object
  def self.pre_req(request_object, env)
    init_hider(env)
    return unless self.methods(false).include? :pre_get

    request_object
  end

  # Filter Response Object
  def self.post_res(response_object, env)
    init_hider(env)
    return unless self.methods(false).include? :post_get
    json = decode_response_body(response_object.body)
    post_get(json, env)
    response_object.body = encode_response_body(json)
  end

  def self.pre_post(param, fullpath, env)
  end

  def self.post_post(body, env)
  end
end



