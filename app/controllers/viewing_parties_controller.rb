class ViewingPartiesController < ApplicationController
  def new
    @facade = MovieFacade.new(params)
  end

  def create
    user = User.find(params[:user_id])
    viewing_party = ViewingParty.create(viewing_party_params)
    UserViewingParty.create(user_id: user.id, viewing_party_id: viewing_party.id, host: true)
    redirect_to user_path(user)
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :time, :movie_id, :movie_title)
  end
end
