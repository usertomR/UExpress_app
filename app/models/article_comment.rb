class ArticleComment < ApplicationRecord
  # association
  belongs_to :article
  belongs_to :user
  has_many :nice_to_article_comments, dependent: :destroy

  # Action Textの使用
  has_rich_text :comment

  validates :article_id, presence: true
  validates :user_id, presence: true
  validates :comment, presence: true
end
