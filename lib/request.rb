
require 'rest-client'


class Whoever::RequestWrapper
  attr_accessor :method, :fullpath, :headers, :body

  def initialize(method, fullpath, headers, body = nil)
    @method = method
    @fullpath = fullpath
    @headers = headers
    @body = body
  end

  def do_request
    request_uri = $config['api_proxy_base'].sub(%r{\/$}, '')
    request_uri << fullpath

    puts "#{method}: #{request_uri}"
    response = case method
               when :GET
                 RestClient.get request_uri#, headers
               when :POST
                 RestClient.post request_uri, body#, headers
               when :PUT
                 RestClient.put request_uri, body#, headers
               when :DELETE
                 RestClient.delete request_uri#, headers
               end

    [response.code, response.headers, response.body]
  end

end
