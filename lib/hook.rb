
require 'cgi'
require 'uri'
require 'json'

require_relative 'request'
require_relative 'response'
require_relative 'hider'

class Hook
  def self.decode_request_params(req)
    return CGI.parse(URI.parse(req.fullpath).query || '')
  end
  def self.encode_request_uri(orig_uri, param_hash)
    u = URI.parse(orig_uri)
    u.query = URI.encode_www_form(param_hash)
    return u.to_s
  end

  def self.decode_request_body(req)
    return CGI.parse(req.body)
  end
  def self.encode_request_body(body_param)
    return URI.encode_www_form(body_param)
  end

  def self.decode_response_body(res)
    return JSON.parse(res.body)
  end
  def self.encode_response_body(json_hash)
    utf8_str = JSON.dump(json_hash)
    ascii_str = ''
    utf8_str.each_char do |c|
      if c.ord <= 127
        ascii_str << c
      else
        ascii_str << "\\u#{c.ord.to_s(16)}"
      end
    end
    ascii_str
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

