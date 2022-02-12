module ApplicationHelper
  # ページネーションgem:pagyの使用に必要な記述
  include Pagy::Frontend

  # ページ毎の完全なタイトルを返す。
  def full_title(page_title = '')
    base_title = "UExpress"
    if base_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
