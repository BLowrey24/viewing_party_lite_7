require "rails_helper"

RSpec.describe "Movie Details Page", type: :feature do
  before(:each) do
    lotr_details = File.read("./spec/fixtures/lord_of_the_rings_fellowship/details.json")
    lotr_credits = File.read("./spec/fixtures/lord_of_the_rings_fellowship/credits.json")
    lotr_reviews = File.read("./spec/fixtures/lord_of_the_rings_fellowship/reviews.json")

    @movie = Movie.new(JSON.parse(lotr_details, symbolize_names: true))

    @credits = JSON.parse(lotr_credits, symbolize_names: true)
    @reviews = JSON.parse(lotr_reviews, symbolize_names: true)

    @user = User.create!(name: "John", email: "john@example.com", password: "password")

    # This stubs out the API call to the movie details endpoint
    stub_request(:get, "https://api.themoviedb.org/3/movie/120?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_details)

    # This stubs out the API call to the movie credits endpoint
    stub_request(:get, "https://api.themoviedb.org/3/movie/120/credits?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_credits)

    # This stubs out the API call to the movie reviews endpoint
    stub_request(:get, "https://api.themoviedb.org/3/movie/120/reviews?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_reviews)

    stub_request(:get, "https://api.themoviedb.org/3/movie/?api_key=#{ENV['MOVIE_API_KEY']}")
      .to_return(status: 200, body: lotr_details)
  end

  describe "when I visit the movie details page" do
    context "Happy Path" do
      before(:each) do
        visit user_movie_path(@user, 120)
      end

      it "displays a link to the home page, 'Viewing Party', and the movie's title at the top of the page" do
        expect(page).to have_link("Home")
        expect(page).to have_content("Viewing Party")

        within("#title") do
          expect(page).to have_content(@movie.title)
        end
      end

      it "displays a button that takes the user back to the discover page" do
        within("#buttons") do
          expect(page).to have_button("Discover Page")

          click_button("Discover Page")
        end

        expect(current_path).to eq(user_discover_index_path(@user))
      end

      it "displays a button that takes user to a page to create a viewing party" do
        within("#buttons") do
          expect(page).to have_button("Create Viewing Party for #{@movie.title}")

          click_button("Create Viewing Party for #{@movie.title}")
        end
        expect(current_path).to eq(new_user_movie_viewing_party_path(@user.id, @movie.id))
      end

      it "displays the movie's vote average rounded to one decimal place" do
        within("#movie-details") do
          expect(page).to have_content("Vote: 8.4")
        end
      end

      it "displays the movie's runtime in hours and minutes" do
        within("#movie-details") do
          expect(page).to have_content("Runtime: 2hr 59min")
        end
      end

      it "displays the movie's genres" do
        within("#movie-details") do
          expect(page).to have_content("Genre: Adventure, Fantasy, Action")
        end
      end

      it "displays the movie's summary" do
        within("#movie-summary") do
          expect(page).to have_content("Summary:")
          expect(page).to have_content(@movie.summary)
        end
      end

      it "displays the movie's top 10 cast members" do
        within("#movie-cast") do
          expect(page).to have_content("Cast:")

          @credits[:cast][0..9].each do |cast_member|
            expect(page).to have_content("#{cast_member[:name]} as #{cast_member[:character]}")
          end
        end
      end

      it "displays the number of movie's reviews, the reviews, and thier authors" do
        within("#movie-reviews") do
          expect(page).to have_content("#{@reviews[:results].count} Reviews:")

          @reviews[:results].each do |review|
            expect(page).to have_content(review[:content][0..10])
            expect(page).to have_content(review[:author])
          end
        end
      end
    end
  end
end
