class CreateCuriousQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :curious_questions do |t|
      t.integer :user_id
      t.integer :question_id
      t.timestamps
    end
    add_index :curious_questions, :user_id
    add_index :curious_questions, :question_id
    add_index :curious_questions, [:user_id, :question_id], unique: true
  end
end
