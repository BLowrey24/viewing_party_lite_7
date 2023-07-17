require 'rails_helper'

RSpec.describe "Logging In" do
  describe "happy path" do
    it "can log in with valid credentials" do
      user = User.create!(name: 'Boston', email: 'boss@example.com', password: '12password34')

      visit "/"

      click_button "Login"
      expect(current_path).to eq("/login")

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_on "Login"

      expect(current_path).to eq("/users/#{user.id}")
      expect(page).to have_content("Welcome, #{user.name}")
    end
  end

  describe 'sad path' do
    it 'cannot log in with bad credentials' do
      user = User.create!(name: 'Boston', email: 'boss@example.com', password: '12password34')

      visit '/login'

      fill_in "Email", with: user.email
      fill_in "Password", with: "incorrect password"
      click_on "Login"

      expect(current_path).to eq('/login')
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end
