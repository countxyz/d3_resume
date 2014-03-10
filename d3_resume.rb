require 'sinatra/base'

class D3Coffee < Sinatra::Base

  get ('/') { erb :index }
end
