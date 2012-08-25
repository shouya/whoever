
require 'rest-client'

require_relative 'whoever'


class Whoever::ResponseWrapper
  attr_accessor :body, :headers, :status_code

  def initialize(headers, body, status_code)
    @headers = headers
    @body = body
    @status_code = status_code
  end

end

