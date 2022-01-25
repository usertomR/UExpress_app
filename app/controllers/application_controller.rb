class ApplicationController < ActionController::Base
  include SessionsHelper
  # ページネーションpagyを使用するのに必要な記述。別にここで書く必要はない
  include Pagy::Backend
end
