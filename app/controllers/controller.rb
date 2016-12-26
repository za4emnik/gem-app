class Controller

attr_accessor :status, :headers, :body

  def status_ok
    @status = 200
    @headers = {"Content-Type" => "text/html"}
  end

  def not_found
    @status = 404
    @headers = {"Content-Type" => "text/html"}
    @body = 'Not found!'
  end

  def redirect_to(url)
    Rack::Response.new { |response| response.redirect(url) }
  end

  def get_binding
    binding
  end

  def self.before_filter(method, *origins)
    origins.each do |origin|
      m = instance_method(origin)
      define_method(origin) do |*args|
        self.send(method)
        m.bind(self).(*args)
      end
    end
  end

  def self.after_filter(method, *origins)
    origins.each do |origin|
      m = instance_method(origin)
      define_method(origin) do |*args|
        m.bind(self).(*args)
        self.send(method)
      end
    end
  end

end
