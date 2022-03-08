class AnswerToQuestion < ApplicationRecord
  # association
  belongs_to :question
  belongs_to :user
  # Action Textの使用
  has_rich_text :answer
  # 上記回答に対するコメント機能の実装
  has_many :comment_to_answers, dependent: :destroy
  # 上記回答に対するnice機能
  has_many :nice_to_answers, dependent: :destroy

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :answer, presence: true
end
