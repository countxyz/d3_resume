ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require './app'

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  config.include Capybara::DSL

  Capybara.register_driver :poltergeist do |app|
    options = { js_errors: false }
    Capybara::Poltergeist::Driver.new(app, options)
  end

  Capybara.javascript_driver = :poltergeist
  Capybara.app = D3Resume

  Kernel.srand config.seed
end
