

require_relative 'hook'

class GetHook < Hook
  # Filter Request Object
  def self.pre_req(request_object, env)
    init_hider(env)
    return unless self.methods(false).include? :pre_get
    param_hash = decode_request_params(request_object)
    pre_get(param_hash, request_object.fullpath, env)
    request_object.fullpath = \
        encode_request_uri(request_object.fullpath, param_hash)
  end

  # Filter Response Object
  def self.post_res(response_object, env)
    init_hider(env)
    return unless self.methods(false).include? :post_get
    json = decode_response_body(response_object.body)
    post_get(json, env)
    response_object.body = encode_response_body(json)
  end

  def self.pre_get(param, fullpath, env)
  end

  def self.post_get(body, env)
  end
end



