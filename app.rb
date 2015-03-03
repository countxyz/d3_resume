require 'sinatra/base'

class D3Resume < Sinatra::Base

  get ('/') { erb :index }
end
