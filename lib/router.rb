require './app/controllers/controller.rb'
class Router < Controller

  def initialize(env)
    @routes = YAML.load_file('./app/config/routes.yml')
    @env = env
  end

  def run
    if @routes.include?(@env['REQUEST_PATH'])
      controller_name, action_name = @routes[@env['REQUEST_PATH']].split("#")
      klass = Object.const_get "#{controller_name.capitalize}Controller"
      klass = klass.new(@env)
      result = klass.send(:"#{action_name}")
      self.body = klass.response || result
      klass.remove_errors unless self.body.kind_of?(Rack::Response)
      status_ok
    else
      not_found
    end
    get_response
  end

  def get_response
    return [self.status, self.headers, [self.body]] if self.body.kind_of?(String)
    self.body
  end
end
