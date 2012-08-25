

require_relative 'request'
require_relative 'response'

class GetHook
  # Filter Request Object
  def self.pre_get(request_object, env)
  end

  # Filter Response Object
  def post_get(response_object, env)
  end
end



