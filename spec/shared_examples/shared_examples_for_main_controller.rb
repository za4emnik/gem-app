RSpec.shared_examples "should call method" do |method|

  let(:env) { env = { 'rack.session' => {'game' => nil}} }
  subject { MainController.new(env) }

    it 'should call #remove_game' do
      expect(subject).to receive(:remove_game)
      subject.send(method)
    end
end
