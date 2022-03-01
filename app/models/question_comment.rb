class QuestionComment < ApplicationRecord
  belongs_to :question
  belongs_to :user
  # Action Textの使用
  has_rich_text :comment

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :comment, presence: true
end
