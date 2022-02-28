class ArticleComment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  # Action Textの使用
  has_rich_text :comment

  validates :article_id, presence: true
  validates :user_id, presence: true
  validates :comment, presence: true
end
