
require 'json'
require 'uri'
require 'cgi'

require_relative '../get_hook'

class UserShowHook < GetHook
  def self.pre_get(req, session)
    uri = URI.parse(req.fullpath)
    qry = CGI.parse(uri.query)
    qry['screen_name'] = '54c3'
    uri.query = URI.encode_www_form(qry)
    req.fullpath = uri.to_s
  end

  def self.post_get(res, session)
    hsh = JSON.parse(res.body)
    hsh['screen_name'] = 'yashou'
    res.body = JSON.dump(hsh)
  end
end
