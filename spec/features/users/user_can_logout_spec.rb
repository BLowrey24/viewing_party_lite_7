require "rails_helper"

RSpec.describe "As a User who is logged in I can logout" do
  describe "when I visit the landing page" do
    it "if not logged in I see two buttons one to register and one to login" do
      visit root_path
      expect(page).to have_button("Register")
      expect(page).to have_button("Login")
      expect(page).to_not have_button("Log Out")
    end

    it "if logged in I see a button to logout" do
      @logged_in_user = User.create!(name: "Boston", email: "baston@example.com", password: "12password34")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@logged_in_user)

      visit root_path
      expect(page).to_not have_button("Register")
      expect(page).to_not have_button("Login")
      expect(page).to have_button("Logout")
    end

    it "as a logged in user I can logout" do
      visit "/register"
      fill_in "Name", with: "boston"
      fill_in "Email", with: "boston@example.com"
      fill_in "Password", with: "password"
      fill_in "Password Confirmation", with: "password"
      click_button "Create New User"
      click_link("Home")

      click_button("Logout")
      expect(current_path).to eq(root_path)
      expect(page).to have_button("Login")
      expect(page).to have_button("Register")
    end
  end
end