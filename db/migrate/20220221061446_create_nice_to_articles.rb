class CreateNiceToArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :nice_to_articles do |t|
      t.integer :user_id
      t.integer :article_id
      t.timestamps
    end
    add_index :nice_to_articles, :user_id
    add_index :nice_to_articles, :article_id
    add_index :nice_to_articles, [:user_id, :article_id], unique: true
  end
end
