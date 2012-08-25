
# Whoever

## User Operation



## Field to be blocked
### User
* screen_name
* location (opt)
* description
* profile_image_url
* profile_image\_url_https

### Tweet
* text (filtered)
* source




## Framework

### API proxy
* Request Redirection

### Hook Handling
* establishing hooks
* #{pre/post}\_#{method}_hook
* finding_hook
* hook_processing

#### Request object
class RequestWrapper
  attr_accessor :method, :request_uri, :body
end

#### Establishing hooks

w = Whoever.new
w.register_hook(:GET, %r{/user/show/json/.*}, UserHook)
w.register_hook(:POST, %r{/user/show/json/.*}, UserHook)

w.serve



