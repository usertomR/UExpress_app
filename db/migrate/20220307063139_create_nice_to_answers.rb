class CreateNiceToAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :nice_to_answers do |t|
      t.integer :user_id
      t.integer :answer_to_question_id
      t.timestamps
    end
  end
end
