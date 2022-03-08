class Article < ApplicationRecord
  # アソシエーション
  belongs_to :user
  # 記事のnice数を記録するために記入
  has_many :nice_to_articles, class_name: "NiceToArticle",
                                dependent: :destroy,
                                inverse_of: :article
  has_many :sum_nice_per_article, through: :nice_to_articles, source: :user
  # 記事のブックマーク機能
  has_many :article_bookmarks, class_name: "ArticleBookmark",
                                dependent: :destroy,
                                inverse_of: :article
  has_many :sum_bookmark_per_article, through: :article_bookmarks, source: :user
  # 記事へのコメント機能
  has_many :article_comments, dependent: :destroy

  # 「個人の」記事について、更新経過時間の短い記事を上に表示する。
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :articletext, presence: true
  validates :accuracy_text, presence: true
  validates :difficultylevel_text, presence: true
  validates(:title, presence: true, length: { maximum: 100 },
            uniqueness: { case_sensitive: false })

  # 小中高向けの、少なくともどれか1つは選ぶ制約のカスタムバリデーションを読み込む
  include ActiveModel::Validations
  validates_with TargetValidator

  # Action Textのリッチテキストを使用
  has_rich_text :articletext

  # 個人記事検索用のスコープ(showアクション)
  # where(id: nil)で、強制的にActiveRecord::Relationの中身を空にしている

  # content = params[:content]
  scope :title, ->(content) {
    if content.blank?
      where(id: nil)
    else
      where("title LIKE ?", '%' + content + '%')
    end
  }
  # dif_select = params[:difficulty_select]
  def self.difficulty(dif_select)
    where(difficultylevel_text: dif_select)
  end

  # ac_select = params[:accuracy_select]
  def self.accuracy(ac_select)
    where(accuracy_text: ac_select)
  end

  # term_from = params[:term_from], term_to = params[:term_to]
  def self.term(term_from, term_to)
    if term_from == "" || term_to == ""
      where(id: nil)
    else
      where("updated_at >= :start_date AND updated_at <= :end_date",
      { start_date: term_from, end_date: term_to })
    end
  end
end
