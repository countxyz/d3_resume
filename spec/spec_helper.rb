ENV['RACK_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + '/../app.rb')

require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/poltergeist'

Dir['./spec/support/**/*.rb'].each{|f| require f}

RSpec.configure do |config|
  config.include Capybara::DSL
  Capybara.javascript_driver = :poltergeist
  Capybara.app = Sinatra::Application.new
end
