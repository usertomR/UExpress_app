class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.integer :accuracy_text
      t.integer :difficultylevel_text
      t.text :questiontext
      t.boolean :Eschool_level, default: false
      t.boolean :JHschool_level, default: false
      t.boolean :Hschool_level, default: false
      t.boolean :solve, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :questions, [:user_id, :updated_at]
  end
end
