class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, class_name: "Entry", dependent: :destroy
end
