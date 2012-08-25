
require 'cgi'
require 'uri'
require 'json'

require_relative 'request'
require_relative 'response'
require_relative 'hider'

class Hook
  def self.decode_request_params(req)
    return CGI.parse(URI.parse(req.fullpath).query)
  end
  def self.encode_request_uri(orig_uri, param_hash)
    u = URI.parse(orig_uri)
    u.query = URI.encode_www_form(param_hash)
    return u.to_s
  end

  def self.decode_response_body(res)
    return JSON.parse(res.body)
  end
  def self.encode_response_body(json_hash)
    return JSON.dump(json_hash)
  end

  def self.init_hider(env)
    return if env.key? :hider
    env[:hider] = Hider.new
  end

  def self.pre_req(req, env)
  end

  def self.post_res(req, env)
  end
end

