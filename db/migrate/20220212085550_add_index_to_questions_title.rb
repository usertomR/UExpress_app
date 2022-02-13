class AddIndexToQuestionsTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :title, unique: true
  end
end
