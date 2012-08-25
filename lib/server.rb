

require 'sinatra/base'

require_relative 'whoever'

require_relative 'request'
require_relative 'response'



class Whoever::Server < Sinatra::Base
  enable :sessions

  get '/' do
    erb :index
  end

  helpers do
    def present(response)
      status response.status_code
      headers response.headers
      body response.body
    end
  end

  [:get, :post, :delete, :put].each do |method|
    eval <<-HERE
        #{method.to_s.downcase} %r{/.*} do
          req_headers = request.env.inject({}) do |acc, (k,v)|
            acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc
          end
          req = Whoever::RequestWrapper.new(request.method,
                                            request.fullpath,
                                            req_headers,
                                            request.body.read)

          hook = hook_manager.find_hook(#{method.upcase}, req.fullpath)
          hook.pre_get(req) if hook

          res = Whoever::ResponseWrapper.new(*req.do_request)

          hook.post_get(res) if hook

          present(res)
        end
    HERE
  end

end
