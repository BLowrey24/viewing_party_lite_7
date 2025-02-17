require "rails_helper"

RSpec.describe "user registration page", type: :feature do
  before(:each) do
    @user1 = User.create!(name: "boston", email: "boston@example.com")

    visit "/register"
  end

  describe "when I visit the user registration page" do
    context "Happy Path" do
      it "I see a link to return to the landing page" do
        expect(page).to have_link("Home")

        click_link "Home"

        expect(current_path).to eq("/")
      end

      it "I see a form to register a user" do
        expect(page).to have_content("Register a New User")

        within("#user-registration") do
          expect(page).to have_content("Name:")
          expect(page).to have_content("Email:")
          expect(page).to have_button("Create New User")
        end
      end

      it "I can register a new user" do
        expect(User.all.count).to eq(1)

        fill_in "Name", with: "Myles"
        fill_in "Email", with: "Myles@example.com"
        click_button "Create New User"

        expect(current_path).to eq("/users/#{User.last.id}")
        expect(User.all.count).to eq(2)
      end
    end

    context "Sad Path" do
      it "I see a flash message if I do not fill out all fields" do
        expect(User.all.count).to eq(1)

        fill_in "Name", with: ""
        fill_in "Email", with: "Myles@example.com"
        click_button "Create New User"

        expect(page).to have_content("Please fill in all fields. Email must be unique.")
        expect(User.all.count).to eq(1)
      end

      it "I see a flash message if I do not use a unique email" do
        expect(User.all.count).to eq(1)
        expect(User.first[:email]).to eq("boston@example.com")

        fill_in "Name", with: "boston"
        fill_in "Email", with: "boston@example.com"
        click_button "Create New User"

        expect(page).to have_content("Please fill in all fields. Email must be unique.")
        expect(User.all.count).to eq(1)
      end
    end
  end
end
