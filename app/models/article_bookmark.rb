class ArticleBookmark < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :article_id, presence: true
  validates :user_id, presence: true
end
