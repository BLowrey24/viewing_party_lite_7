require "rails_helper"

RSpec.describe "user dashboard page", type: :feature do
  before(:each) do
    @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
    @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
    @user3 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")
  end

  describe "when I visit a user's dashboard" do
    context "User 1" do
      before(:each) do
        visit user_path(@user1)
      end

      it "displays a link to the home page and 'Viewing Party' at the top of the page" do
        expect(page).to have_link("Home")
        expect(page).to have_content("Viewing Party")
      end

      it "displays '<user's name>'s Dashboard' after 'Viewing Party" do
        within("#title") do
          expect(page).to have_content("#{@user1.name}'s Dashboard")
        end
      end

      it "displays a button that links to 'Discover Movies'" do
        expect(page).to have_button("Discover Movies")

        click_button "Discover Movies"

        expect(current_path).to eq(user_discover_index_path(@user1.id))
      end
    end

    context "User 2" do
      before(:each) do
        visit user_path(@user2)
      end

      it "displays '<user's name>'s Dashboard' after 'Viewing Party" do
        within("#title") do
          expect(page).to have_content("#{@user2.name}'s Dashboard")
        end
      end

      it "displays a button to 'Discover Movies'" do
        expect(page).to have_button("Discover Movies")

        click_button "Discover Movies"

        expect(current_path).to eq(user_discover_index_path(@user2.id))
      end
    end
  end
end
