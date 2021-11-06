class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new  #form_with の引数として利用
  end

  def create
    @user = User.new(user_params)
    if @user.save

    else
      render 'new'
    end
  end

      private
        def user_params
          params.require(:user).permit(:name,:email,:password,
                    :password_confirmation,:selfintrodution)
        end

end
