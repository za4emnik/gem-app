require "spec_helper"

RSpec.feature "Game process", :type => :feature do
  context "home page" do
    scenario 'game exist' do
      visit '/'
    end
  end
end
