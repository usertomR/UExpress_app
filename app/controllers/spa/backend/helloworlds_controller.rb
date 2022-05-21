class Spa::Backend::HelloworldsController < ApplicationController
  def show
    # user_state・・・ログインしているか、管理者(ログイン前提)かを判別する。
    user_state = { login: "", admin: "" }
    # ログインしているかどうかの判別
    if logged_in?
      user_state[:login] = "true"
    else
      user_state[:login] = "false"
    end
    # ログインしている管理者かどうかを判別する
    if current_user && current_user.admin?
      user_state[:admin] = "true"
    else
      user_state[:admin] = "false"
    end

    render json: user_state
  end
end
