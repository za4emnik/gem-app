require 'spec_helper'

RSpec.describe Controller do

  context '#initialize' do
    subject { Controller.new }
    attr_accessors = %w(status headers body)

    attr_accessors.each do |attr|
      it "calss should have :#{attr} attr_accessor" do
        should have_attr_accessor(:"#{attr}")
      end
    end
  end

  context '#status_ok' do
    subject { Controller.new }

    before do
      subject.status_ok
    end

    it 'status should be equal \'200\'' do
      expect(subject.status).to eq(200)
    end
  end

  context '#not_found' do
    subject { Controller.new }

    before do
      subject.not_found
    end

    it 'status should be equal \'404\'' do
      expect(subject.status).to eq(404)
    end

    it 'body should be equal \'Not found\'' do
      expect(subject.body).to eq('Not found!')
    end
  end

  context '#redirect_to' do
    subject { Controller.new }

    it 'return value should be instance of Rack::Response' do
      expect(subject.redirect_to('/run')).to be_kind_of(Rack::Response)
    end

    it 'status should be 302' do
      expect(subject.redirect_to('/run').instance_variable_get(:@status)).to eq(302)
    end

    it 'location should be \'/run\'' do
      expect(subject.redirect_to('/run').instance_variable_get(:@header)['location']).to eq('/run')
    end
  end

  context '#get_binding' do
    subject { Controller.new }

    it 'return value should be instance of Binding' do
      expect(subject.get_binding).to be_kind_of(Binding)
    end
  end

  context '#before_filter' do
    subject { Controller.new }

    it 'should be call method #test' do
      #allow(subject).to receive(:test).and_return true
      #allow(subject).to receive(:origin).and_return true
      #expect(subject).to receive(:test)
      #subject.send(:before_filter).with('test', 'origin')
    end
  end
end
