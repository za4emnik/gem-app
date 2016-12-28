require 'rack'
require 'bundler/setup'
require 'codebreaker_gem'
require 'require_all'
require_all './spec/shared_examples'
require_all './app/controllers'
require_all './lib'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.include Capybara::DSL
  config.alias_example_group_to :feature, :capybara_feature => true, :type => :feature
  config.alias_example_to :scenario
  config.alias_example_to :xscenario, :skip => "Temporarily skipped with xscenario"
  config.alias_example_to :fscenario, :focus => true
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

config = File.read('./config.ru')
app = Rack::Builder.new do
  eval "#{config}"
end

Capybara.configure do |config|
  config.app = app
  config.app_host = "http://localhost:9292"
  config.default_driver = :poltergeist
end
