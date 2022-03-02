class CreateCommentToAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_to_answers do |t|
      t.integer :user_id
      t.integer :answer_to_question_id
      t.text :comment
      t.timestamps
    end
    add_index :comment_to_answers, [:answer_to_question_id, :created_at]
  end
end
