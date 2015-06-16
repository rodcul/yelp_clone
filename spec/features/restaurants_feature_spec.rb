require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'Chipotle')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Chipotle')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      User.create(email: 'test@test.com', password: 'test1234')
      visit '/users/sign_in'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'test1234'
      click_button 'Log in'
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Chipotle'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Chipotle'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    it 'is not valid unless it has a unique name' do
      Restaurant.create(name: "Moe's Tavern")
      restaurant = Restaurant.new(name: "Moe's Tavern")
      expect(restaurant).to have(1).error_on(:name)
    end
  end

  context 'viewing restaurants' do
    let!(:chipotle) { Restaurant.create(name: 'Chipotle') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Chipotle'
      expect(page).to have_content 'Chipotle'
      expect(current_path).to eq "/restaurants/#{chipotle.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'Chipotle' }

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit Chipotle'
      fill_in 'Name', with: 'Chipotle Mexican Grill'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Chipotle Mexican Grill'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before { Restaurant.create name: 'Trade' }

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete Trade'
      expect(page).not_to have_content 'Trade'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end
end
