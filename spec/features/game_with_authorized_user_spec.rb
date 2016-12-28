require "spec_helper"
RSpec.feature 'Game with authorized user' do

  before do
    visit '/'
    fill_in 'player_name', with: 'Mike'
    click_button 'START'
  end

  after { Capybara.reset_sessions! }

  context 'run' do
    scenario 'should contain attems with full quantity of attems' do
      attempts = CodebreakerGem::Game.const_get('ATTEMPTS')
      expect(page).to have_content "Attempts : #{attempts}"
    end

    scenario 'should contain HINT' do
      expect(page).to have_content "HINT"
    end

    scenario 'should contain hints with full quantity of hints' do
      hint = CodebreakerGem::Game.const_get('HINTS')
      expect(page).to have_content "Hints : #{hint}"
    end

    scenario 'should show warning message if guess is empty' do
      click_button 'GO'
      expect(page).to have_content "Warning!"
    end

    scenario 'should show warning message if guess is string' do
      fill_in 'guess', with: 'test_string'
      click_button 'GO'
      expect(page).to have_content "Warning!"
    end
  end

  context 'hint' do
    scenario 'should contain HINT with hint value' do
      click_link('HINT')
      hint = CodebreakerGem::Game.instance_variable_get(:@hint)
      expect(page).to have_content hint
    end
  end

  context 'home' do
    scenario 'should redirect to /run' do
      click_link('Home')
      expect(page).to have_current_path('/run')
    end
  end

  context 'new game' do
    scenario 'should redirect to /run' do
      click_link('Start new game')
      expect(page).to have_current_path('/run')
    end

    scenario 'should contain attems with full quantity of attems' do
      fill_in 'guess', with: '1234'
      click_button('GO')
      click_link('Start new game')
      attempts = CodebreakerGem::Game.const_get('ATTEMPTS')
      expect(page).to have_content "Attempts : #{attempts}"
    end
  end

  context 'achievements' do
    scenario 'should redirect to /achievements' do
      click_link('Show scores')
      expect(page).to have_current_path('/achievements')
    end
  end

  context 'quit' do

    scenario 'should redirect to /' do
      click_link('Quit')
      expect(page).to have_current_path('/')
    end
  end

  context 'You lose' do

    scenario 'should have content \'You lose :(\'' do
      CodebreakerGem::Game.const_get('ATTEMPTS').times do
        fill_in 'guess', with: '1234'
        click_button('GO')
      end
      expect(page).to have_content('You lose :(')
    end
  end
end
