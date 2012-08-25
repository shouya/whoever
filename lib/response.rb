
require 'rest-client'

require_relative 'whoever'


class Whoever::ResponseWrapper
  attr_accessor :body, :headers, :status_code

  def initialize(status_code, headers, body)
    @headers = headers
    @body = body
    @status_code = status_code
  end

end

