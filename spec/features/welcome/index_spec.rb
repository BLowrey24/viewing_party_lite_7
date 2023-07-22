require "rails_helper"

RSpec.describe "landing page", type: :feature do
  describe "when I visit the landing page" do
    it "displays a link to the home page, the title of the application, and a button to register" do
      @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
      @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
      @user3 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")

      visit root_path
      expect(page).to have_link("Home")
      expect(page).to have_content("Viewing Party")
      expect(page).to have_button("Register")
      expect(page).to have_button("Login")

      expect(page).to_not have_content("Existing Users")
      expect(page).to_not have_link(@user1.email)
      expect(page).to_not have_link(@user2.email)
      expect(page).to_not have_link(@user3.email)
    end

    it "displays a list of existing users when logged in" do
      @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
      @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
      @user3 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit root_path

      expect(page).to have_content("Current Users")
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.email)
      expect(page).to have_content(@user3.email)
    end
  end
end
