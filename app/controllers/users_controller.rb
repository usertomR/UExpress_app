class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :index]

  def index
    @users = User.where(activated: true)
  end

  # 有効化されているユーザーのみ表示
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "登録したemailを確認しよう!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  # @user=・・がないのは、before_actionのcorrect_userで@userを定義しているから。
  def edit
  end

  # @user=・・がないのは、before_actionのcorrect_userで@userを定義しているから。
  def update
    if @user.update(user_params)
      flash[:success] = "アカウント更新成功!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

      private

  def user_params
    params.require(:user).permit(:name, :email, :password,
              :password_confirmation, :selfintrodution, :avatar)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
