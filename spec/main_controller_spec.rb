require 'spec_helper'

  RSpec.describe MainController do

  context '#initialize' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    [['@irb', RenderIRB],
    ['@request', Rack::Request]].each do |item|
      it "#{item[0]} should be instance of #{item[1]} class" do
        expect(subject.instance_variable_get(:"#{item[0]}")).to be_kind_of(item[1])
      end
    end

    it '@session[errors] should be instance of Array class' do
      expect(subject.instance_variable_get(:@session)['errors']).to be_kind_of(Array)
    end

    it '@session[game] should be instance of CodebreakerGem::Game class' do
      expect(subject.instance_variable_get(:@session)['game']).to be_kind_of(CodebreakerGem::Game)
    end
  end

  context '#index' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    after do
      subject.index
    end

    it 'should redirect to \'/run\' if @session[player] not nil' do
      subject.instance_variable_get(:@session)['player'] = 'Mike'
      expect(subject).to receive(:redirect_to).with('/run')
    end

    it 'should call #save_name if received POST' do
      allow(subject.instance_variable_get(:@request)).to receive(:post?).and_return true
      expect(subject).to receive(:save_name)
    end
  end

  context '#run' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it 'should call #you_lose if attempts have ended' do
      subject.instance_variable_get(:@session)['game'].instance_variable_set(:@attempts, 0)
      expect(subject).to receive(:you_lose)
      subject.run
    end
  end

  context '#chek' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it 'hould return #you_won if codes coincide' do
      subject.instance_variable_get(:@session)['game'].instance_variable_set(:@secret_code, '1234')
      subject.instance_variable_get(:@request).instance_variable_set(:@params, {'guess' => '1234'})
      expect(subject).to receive(:you_won)
      subject.check
    end
  end

  context '#you_won' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    after do
      subject.you_won
    end

    %w(save_game remove_game).each do |method|
      it "should call ##{method}" do
        expect(subject).to receive(:"#{method}")
      end
    end
  end

  context '#you_lose' do
    it_should_behave_like 'should call method', 'you_lose'
  end

  context '#new_game' do
    it_should_behave_like 'should call method', 'new_game'
  end

  context '#quit' do
    it_should_behave_like 'should call method', 'quit'
  end

  context '#save_game' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it 'player name should be true' do
      expect(subject.instance_variable_get(:@session)['game']).to receive(:save_achievement)
      subject.save_game
    end
  end

  context '#save_name' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it '@session[player] should be equal Mike if received POST' do
      allow(subject.instance_variable_get(:@request)).to receive(:post?).and_return true
      subject.instance_variable_get(:@request).instance_variable_set(:@params, {'player_name' => 'Mike'})
      subject.save_name
      expect(subject.instance_variable_get(:@session)['player']).to eq('Mike')
    end

    it 'should call #set_error if name empty' do
      subject.instance_variable_get(:@request).instance_variable_set(:@params, {'player_name' => ''})
      expect(subject).to receive(:set_error).with('Name can\'t be empty!')
      subject.save_name
    end

    it 'should redirect to \'/\' if name empty' do
      subject.instance_variable_get(:@request).instance_variable_set(:@params, {'player_name' => ''})
      expect(subject).to receive(:redirect_to).with('/')
      subject.save_name
    end
  end

  context '#achievements' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it '@achievements should be array' do
      subject.achievements
      expect(subject.instance_variable_get(:@achievements)).to be_kind_of(Array)
    end
  end

  context '#set_error' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it '@session[errors] should contain 2 elements' do
      subject.set_error('one')
      subject.set_error('two')
      expect(subject.instance_variable_get(:@session)['errors']).to eq(['one', 'two'])
    end
  end

  context '#remove_errors' do
    let(:env) { env = { 'rack.session' => {'game' => nil}} }
    subject { MainController.new(env) }

    it '@session[errors] should be nil' do
      subject.set_error('one')
      subject.set_error('two')
      subject.remove_errors
      expect(subject.instance_variable_get(:@session)['erros']).to eq(nil)
    end
  end
end
