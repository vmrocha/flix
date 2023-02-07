class UsersController < ApplicationController
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.not_admins
  end

  def show
    @user = User.find_by!(username: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by!(username: params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to movies_url,
                status: :see_other,
                alert: "Account successfully deleted!"
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end

  def require_correct_user
    @user = User.find_by!(username: params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end
end
