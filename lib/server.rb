

require 'sinatra/base'

require_relative 'whoever'

require_relative 'request'
require_relative 'response'



class Whoever::Server < Sinatra::Base
  enable :sessions
  enable :logging

  get '/' do
    erb :index
  end

  def fake_session
    $fs ||= {}
    return $fs
  end


  [:get, :post, :delete, :put].each do |method|
    eval <<-HERE
        #{method.to_s.downcase} %r{/.*} do
          req_headers = request.env.inject({}) do |acc, (k,v)|
            acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc
          end

          req = Whoever::RequestWrapper.new(request.request_method.intern,
                                            request.fullpath,
                                            req_headers,
                                            request.body.read)
          req.headers['connection'] = 'close'

          hook = hook_manager.find_hook(:#{method.upcase}, req.fullpath)
          hook.pre_req(req, fake_session) if hook

          res = Whoever::ResponseWrapper.new(*req.do_request)

          hook.post_res(res, fake_session) if hook

          res.headers['content-type'] = 'application/json; charset=utf-8'
          [res.status_code, res.headers, res.body]
        end
    HERE
  end

end
