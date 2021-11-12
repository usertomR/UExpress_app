class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update]
  before_action :correct_user, only:[:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new  
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:info] = "登録したemailを確認しよう!"
      redirect_to user_url(@user)    
    else
      render 'new'
    end
  end

  def edit      #@user=・・がないのは、before_actionのcorrect_userで@userを定義しているから。
  end

  def update    #@user=・・がないのは、before_actionのcorrect_userで@userを定義しているから。
    if @user.update(user_params)
      flash[:success] = "アカウント更新成功!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  
      private

        def user_params
          params.require(:user).permit(:name,:email,:password,
                    :password_confirmation,:selfintrodution)
        end

        def logged_in_user
          unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
          end
        end

        def correct_user
          @user = User.find(params[:id])
          redirect_to(root_url) unless current_user?(@user)
        end

end
