class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_or_create_user

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to(root_url, notice: 'Logged in!')
    else
      flash.now.alert = 'Email or password is invalid'

      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to(root_url, notice: 'Logged out!')
  end

  private

  def find_or_create_user
    User.where(email: params[:email]).first || User.create!(user_params)
  end

  def user_params
    params.permit(:email, :password)
  end
end
