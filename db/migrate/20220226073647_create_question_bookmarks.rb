class CreateQuestionBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :question_bookmarks do |t|
      t.integer :user_id
      t.integer :question_id
      t.timestamps
    end
    add_index :question_bookmarks, :user_id
    add_index :question_bookmarks, :question_id
    add_index :question_bookmarks, [:user_id, :question_id], unique: true
  end
end
