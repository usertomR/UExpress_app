class CreateQuestionComments < ActiveRecord::Migration[6.0]
  def change
    create_table :question_comments do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :comment
      t.timestamps
    end
    add_index :question_comments, [:question_id, :created_at]
  end
end
