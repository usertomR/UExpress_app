class Article < ApplicationRecord
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
end
