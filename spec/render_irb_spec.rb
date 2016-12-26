require 'spec_helper'

RSpec.describe Router do

  context '#initialize' do
    subject { RenderIRB.new(Binding) }

    it '@context shoul be equal context' do
      expect(subject.instance_variable_get(:@context)).to eq(Binding)
    end
  end

  context '#render' do
    subject { RenderIRB.new(Binding) }

    it 'should render template' do
      allow(subject).to receive(:with_layout).and_return(File.read('./app/views/congrats.html.erb'))
      expect(subject.render('congrats')).to eq(File.read('./app/views/congrats.html.erb'))
    end
  end
end
