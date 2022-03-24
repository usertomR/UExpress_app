class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # 作成時が古いメッセージから順に表示
  scope :created_asc, -> { order(created_at: :asc) }
end
