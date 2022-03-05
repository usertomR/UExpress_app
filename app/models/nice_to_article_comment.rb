class NiceToArticleComment < ApplicationRecord
  belongs_to :user
  belongs_to :article_comment
  validates :user_id, presence: true
  validates :article_comment_id, presence: true
end
