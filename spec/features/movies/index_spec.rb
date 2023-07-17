require "rails_helper"

RSpec.describe "Movie Results page", type: :feature do
  before(:each) do
    top = File.read("./spec/fixtures/top_rated_movies.json")
    search = File.read("./spec/fixtures/search_movies.json")

    @top_rated_movies = JSON.parse(top, symbolize_names: true)[:results]
    @searched_movies = JSON.parse(search, symbolize_names: true)[:results]

    @user1 = User.create!(name: "Myles", email: "myles@example.com", password: "password12")
    @user2 = User.create!(name: "Boston", email: "boston@example.com", password: "password34")

    # This stubs out the API call to the top rated movies endpoint
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: top)

    # This stubs out the API call to the movie search endpoint
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['MOVIE_API_KEY']}&query=The%20ring")
      .to_return(status: 200, body: search)

    visit user_discover_index_path(@user1.id)
  end

  describe "when I press the button to discover top movies" do
    before(:each) do
      click_button("Discover Top Rated Movies")
    end

    it "takes me to the results page and displays the top rated movies" do
      expect(current_path).to eq(user_movies_path(@user1.id))
    end

    it "displays a link to the home page and 'Viewing Party' at the top of the page" do
      expect(page).to have_link("Home")
      expect(page).to have_content("Viewing Party")
    end

    it "displays 'Top Rated Movies' and button that takes the user back to the discover page" do
      within("#query-type") do
        expect(page).to have_content("Top Rated Movies")
      end

      expect(page).to have_button("Discover Page")

      click_button("Discover Page")

      expect(current_path).to eq(user_discover_index_path(@user1))
    end

    it "displays the top 20 movies with their title as a link and vote average" do
      within("#requested-movies") do
        expect(page).to have_content("Title")
        expect(page).to have_content("Vote Average")

        expect(@top_rated_movies.count).to eq(20)

        @top_rated_movies.each do |movie|
          expect(page).to have_link(movie[:title])
          expect(page).to have_content(movie[:vote_average])
        end
      end
    end
  end

  describe "when I search for movies" do
    before(:each) do
      fill_in :search, with: "The ring"

      click_button("Find Movies")
    end

    it "takes me to the results page and displays the top rated movies" do
      expect(current_path).to eq(user_movies_path(@user1.id))
    end

    it "displays a link to the home page and 'Viewing Party' at the top of the page" do
      expect(page).to have_link("Home")
      expect(page).to have_content("Viewing Party")
    end

    it "displays 'Movie Results for: <search>' and button that takes the user back to the discover page" do
      within("#query-type") do
        expect(page).to have_content("Movie Results for: \"The ring\"")
      end

      expect(page).to have_button("Discover Page")

      click_button("Discover Page")

      expect(current_path).to eq(user_discover_index_path(@user1))
    end

    it "displays the top 20 movie matches to search with their title as a link and vote average" do
      within("#requested-movies") do
        expect(page).to have_content("Title")
        expect(page).to have_content("Vote Average")

        expect(@searched_movies.count).to eq(20)

        @searched_movies.each do |movie|
          expect(page).to have_link(movie[:title])
          expect(page).to have_content(movie[:vote_average].round(1))
        end
      end
    end
  end
end
