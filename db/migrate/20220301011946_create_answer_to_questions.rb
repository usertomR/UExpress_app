class CreateAnswerToQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :answer_to_questions do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :answer
      t.timestamps
    end
    add_index :answer_to_questions, [:question_id, :created_at]
  end
end
