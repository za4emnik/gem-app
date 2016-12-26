class RenderIRB

  def initialize(context)
    @context = context
  end

  def render(templ, layout_name = 'app')
    template = File.read("./app/views/#{templ}.html.erb")
    with_layout layout_name do
      ERB.new(template).result(@context.get_binding)
    end
  end

  def with_layout(layout_name)
    layout = File.read("./app/views/layouts/#{layout_name}.html.erb")
    ERB.new(layout).result(binding)
  end
end
