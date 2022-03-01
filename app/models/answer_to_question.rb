class AnswerToQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :user
  # Action Textの使用
  has_rich_text :answer

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :answer, presence: true
end
