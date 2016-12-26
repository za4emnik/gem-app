require 'rack'
require 'bundler/setup'
require 'codebreaker_gem'
require 'require_all'
require_all './spec/shared_examples'
require_all './app/controllers'
require_all './lib'
require "capybara"
require 'capybara/rspec'
require "capybara/dsl"

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.include Capybara::DSL
end

RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object_instance|
    object_instance.respond_to?("#{field}=") &&
    object_instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected have_attr_accessor for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected have_attr_accessor for #{field} not to be defined on #{object_instance}"
  end

  description do
    "checks to see if there is an attr accessor on the supplied object"
  end
end

puts config = File.read('./config.ru')
app = Rack::Builder.new do
  eval "#{config}"
end

Capybara.configure do |config|
  config.app = app
  config.default_driver = :selenium
end
