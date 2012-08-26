

require_relative 'hook'

class PostHook < Hook
  # Filter Request Object
  def self.pre_req(request_object, env)
    init_hider(env)
    return unless self.methods(false).include? :pre_post

    body_param = decode_request_body(request_object)
    query_param = decode_request_params(request_object)

    pre_post(query_param, request_object.fullpath, body_param, env)

    request_object.body = encode_request_body(body_param)
    request_object.fullpath = \
        encode_request_uri(request_object.fullpath, query_param)
  end

  # Filter Response Object
  def self.post_res(response_object, env)
    init_hider(env)
    return unless self.methods(false).include? :post_post
    json = decode_response_body(response_object.body)
    post_post(json, env)
    response_object.body = encode_response_body(json)
  end

  def self.pre_post(param, fullpath, body, env)
  end

  def self.post_post(body, env)
  end
end



