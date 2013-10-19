class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id

      redirect_to(root_url, notice: t('users.create.success'))
    else
      render 'new'
    end
  end

  def destroy
    user = User.find(params[:id])

    if user == current_user
      user.destroy
    end

    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
