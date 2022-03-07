class NiceToAnswer < ApplicationRecord
  belongs_to :answer_to_question
  belongs_to :user

  validates :answer_to_question_id, presence: true
  validates :user_id, presence: true
end
