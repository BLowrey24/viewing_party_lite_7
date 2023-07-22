require "rails_helper"

RSpec.describe "user dashboard page", type: :feature do
  describe "when I visit a user's dashboard" do
    context "User 1" do
      it "displays a link to the home page and 'Viewing Party' at the top of the page" do
        @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit "/dashboard"

        expect(page).to have_link("Home")
        expect(page).to have_content("Viewing Party")
      end

      it "displays '<user's name>'s Dashboard' after 'Viewing Party" do
        @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit "/dashboard"

        within("#title") do
          expect(page).to have_content("#{@user1.name}'s Dashboard")
        end
      end

      it "displays a button that links to 'Discover Movies'" do
        @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit "/dashboard"

        expect(page).to have_button("Discover Movies")

        click_button "Discover Movies"

        expect(current_path).to eq(user_discover_index_path(@user1.id))
      end
    end

    context "User 2" do
      it "displays '<user's name>'s Dashboard' after 'Viewing Party" do
        @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
        visit "/dashboard"

        within("#title") do
          expect(page).to have_content("#{@user2.name}'s Dashboard")
        end
      end

      it "displays a button to 'Discover Movies'" do
        @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
        visit "/dashboard"

        expect(page).to have_button("Discover Movies")

        click_button "Discover Movies"

        expect(current_path).to eq(user_discover_index_path(@user2.id))
      end
    end
  end

  it 'does not allow me to access dashboard if not logged in' do
    @user3 = User.create!(name: "Boston", email: "baston@example.com", password: "12password34", password_confirmation: "12password34")
    visit "/dashboard"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("You must be logged in to access your dashboard")
  end
end
