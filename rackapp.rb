require 'yaml'
require 'require_all'
require 'codebreaker_gem'
require_all './lib'
require_all './app/controllers'

class RackApp
  def call(env)
    Router.new(env).run
  end
end
