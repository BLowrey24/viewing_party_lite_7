require "rails_helper"

RSpec.describe "landing page", type: :feature do
  before(:each) do
    @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
    @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
    @user3 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")

    visit "/"
  end

  describe "when I visit the landing page" do
    it "displays a link to the home page, the title of the application, a button to register, and a list of current users" do
      expect(page).to have_link("Home")
      expect(page).to have_content("Viewing Party")
      expect(page).to have_button("Register")
      expect(page).to have_button("Login")

      within("#existing-users") do
        expect(page).to have_content("Existing Users")
        expect(page).to have_link(@user1.email)
        expect(page).to have_link(@user2.email)
        expect(page).to have_link(@user3.email)
      end
    end
  end
end
