require 'spec_helper'

RSpec.describe Router do

  context '#initialize' do
    subject { Router.new(env) }
    let(:env) { 'env' }

    it '@routes should be equal routes file' do
      expect(subject.instance_variable_get(:@routes)).to eq(YAML.load_file('./app/config/routes.yml'))
    end

    it '@routes should be instance of hash' do
      expect(subject.instance_variable_get(:@routes)).to be_kind_of(Hash)
    end

    it '@env should be equal env' do
      expect(subject.instance_variable_get(:@env)).to eq(env)
    end
  end

  context '#run' do
    subject { Router.new(env) }
    let(:env) { 'env' }

    it 'should call #not_found if route not found' do
      subject.instance_variable_set(:@routes, {"/"=>"main#index"})
      subject.instance_variable_set(:@env, {'REQUEST_PATH' => '/run'})
      expect(subject).to receive(:not_found)
      subject.run
    end

    it 'should call #status_ok if route found' do
      subject.instance_variable_set(:@routes, {"/"=>"main#index"})
      subject.instance_variable_set(:@env, {'REQUEST_PATH' => '/', 'rack.session' => {}})
      expect(subject).to receive(:status_ok)
      subject.run
    end

    it 'should call #get_response' do
      subject.instance_variable_set(:@routes, {"/"=>"main#index"})
      subject.instance_variable_set(:@env, {'REQUEST_PATH' => '/run'})
      expect(subject).to receive(:get_response)
      subject.run
    end
  end

  context '#get_response' do
    subject { Router.new(env) }
    let(:env) { 'env' }

    it 'should return rack array' do
      subject.instance_variable_set(:@body, 'string')
      expect(subject.get_response).to be_kind_of(Array)
    end

    it 'should return body if body not string' do
      subject.instance_variable_set(:@body, Rack::Response)
      expect(subject.get_response).to eq(Rack::Response)
    end
  end
end
