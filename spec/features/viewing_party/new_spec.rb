require "rails_helper"

RSpec.describe "viewing party create page", type: :feature do
  before(:each) do
    lotr_details = File.read("./spec/fixtures/lord_of_the_rings_fellowship/details.json")

    @user1 = User.create!(name: "John", email: "john@example.com", password: "password12")
    @user2 = User.create!(name: "bob", email: "bob@example.com", password: "password34")
    @movie = Movie.new(JSON.parse(lotr_details, symbolize_names: true))

    stub_request(:get, "https://api.themoviedb.org/3/movie/120?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_details)

    stub_request(:get, "https://api.themoviedb.org/3/movie/?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_details)

    visit new_user_movie_viewing_party_path(@user1, 120)
  end

  describe "when I visit the viewing_parties new page" do
    context "Happy Path" do
      it "I see a form to create a viewing party" do
        expect(page).to have_content(@movie.title)
        expect(page).to have_field("Duration")
        expect(page).to have_field("viewing_party[date]")
        expect(page).to have_field("viewing_party[time]")
        expect(page).to have_unchecked_field(@user2.name)
        expect(page).to have_button("Create Viewing Party")
      end

      it "When I click the button to create a viewing party I am taken to the user show page" do
        fill_in "Duration", with: 98
        fill_in "viewing_party[date]", with: Date.today
        fill_in "viewing_party[time]", with: Time.now + 1.hours
        check @user2.name

        click_button("Create Viewing Party")
        expect(current_path).to eq("/dashboard")
        expect(page).to have_content(@movie.title)

        visit(user_path(@user2))
        expect(page).to have_content(@movie.title)
      end
    end
  end
end
