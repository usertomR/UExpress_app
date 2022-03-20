class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, class_name: "Entry", dependent: :destroy

  def self.room_id_present?(sended_user, sending_user)
    sended_user_sum_entries = Entry.where(user_id: sended_user.id)
    sending_user_sum_entries = Entry.where(user_id: sending_user.id)

    sended_user_sum_entries.each do |sended_entry|
      sending_user_sum_entries.each do |sending_entry|
        if sended_entry.room_id == sending_entry.room_id
          return sending_entry.room_id
        end
      end
    end
    return nil
  end
end
