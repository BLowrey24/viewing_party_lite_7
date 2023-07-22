class UsersController < ApplicationController
  def dashboard
  # require 'pry'; binding.pry
    if !current_user
      flash[:alert] = "You must be logged in to access your dashboard"
      redirect_to root_path
    else
      # require 'pry'; binding.pry
      @user = User.find(current_user.id)
    end
  end

  def new; end

  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to "/dashboard"
    else
      redirect_to "/register"
      flash[:alert] = "Sorry, your credentials are bad."
    end
  end


  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end

# def login_form; end

# def login_user
#   user = User.find_by(email: params[:email])
#   if user.authenticate(params[:password])
#     session[:user_id] = user.id
#     flash[:success] = "Welcome, #{user.name}!"
#     redirect_to user_path(user)
#   else
#     flash[:error] = "Sorry, your credentials are bad."
#     render :login_form
#   end
# end

# def show
#   @user = User.find(params[:id])
# end