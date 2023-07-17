require "rails_helper"

RSpec.describe "user's discover page", type: :feature do
  before(:each) do
    @user1 = User.create!(name: "John", email: "john@example.com", password: "password")
    @user2 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
    @user3 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")

    # This stubs out the API call to the top rated movies endpoint
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: File.read("./spec/fixtures/top_rated_movies.json"))

    # This stubs out the API call to the movie search endpoint
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['MOVIE_API_KEY']}&query=The%20ring")
      .to_return(status: 200, body: File.read("./spec/fixtures/search_movies.json"))
  end

  describe "when I visit a user's discover page" do
    context "User 1" do
      before(:each) do
        visit user_discover_index_path(@user1.id)
      end

      it "displays a link to the home page, 'Viewing Party', and 'Discover Movies' at the top of the page" do
        expect(page).to have_link("Home")
        expect(page).to have_content("Viewing Party")

        within("#title") do
          expect(page).to have_content("Discover Movies")
        end
      end

      it "displays a button to 'Discover Top Rated Movies' that links to page showing top 20 movies" do
        expect(page).to have_button("Discover Top Rated Movies")

        click_button("Discover Top Rated Movies")

        expect(current_path).to eq(user_movies_path(@user1.id))

        expect(page).to have_content("Top Rated Movies")
      end

      it "displays a search field to 'Find Movies' that links to page showing top 20 matches" do
        within("#movie-search") do
          expect(page).to have_field("Movie Title:")
          expect(page).to have_button("Find Movies")

          fill_in "Movie Title:", with: "The ring"
          click_button("Find Movies")
        end

        expect(current_path).to eq(user_movies_path(@user1.id))
        expect(page).to have_content("The Lord of the Rings: The Fellowship of the Ring")
      end
    end
  end
end
