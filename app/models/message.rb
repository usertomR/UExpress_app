class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  #バリデーション
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true

  # 作成時が古いメッセージから順に表示
  scope :created_asc, -> { order(created_at: :asc) }
end
