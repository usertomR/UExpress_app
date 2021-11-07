class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

    else
      flash.now[:danger] = 'どちらかまたは両方の入力を間違えています'
      render 'new'
    end

  end

  def destroy
  end

end
