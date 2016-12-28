require 'spec_helper'

RSpec.feature 'Game with unauthorized user' do
  context 'wellcome' do
    before { visit '/' }
    after { Capybara.reset_sessions! }

    scenario 'page should have a status of 200' do
      expect(status_code).to be(200)
    end

    scenario 'should redirect to /run when name entered' do
      fill_in 'player_name', with: 'Mike'
      click_button 'START'
      expect(page).to have_current_path('/run')
    end

    scenario 'should show error if name is empty' do
      fill_in 'player_name', with: ''
      click_button 'START'
      expect(page).to have_content 'Warning!'
      expect(page).to have_current_path('/')
    end
  end

  context 'achievements' do
    scenario 'should have content \'Achievements\'' do
      visit('/achievements')
      expect(page).to have_content 'Achievements'
    end
  end
end
