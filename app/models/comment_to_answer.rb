class CommentToAnswer < ApplicationRecord
  belongs_to :answer_to_question
  belongs_to :user
  # Action Textの使用
  has_rich_text :comment

  validates :answer_to_question_id, presence: true
  validates :user_id, presence: true
  validates :comment, presence: true
end
