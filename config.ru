require 'rack/coffee'
require './d3_resume'

use Rack::Coffee, root: 'public', urls: '/js'

run D3Resume
