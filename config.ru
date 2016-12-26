require './rackapp.rb'
require 'pp'
use Rack::Reloader
use Rack::Session::Pool
use Rack::Static, :urls => ["/app/assets"]
run RackApp.new
