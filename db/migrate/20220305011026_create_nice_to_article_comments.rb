class CreateNiceToArticleComments < ActiveRecord::Migration[6.0]
  def change
    create_table :nice_to_article_comments do |t|
      t.integer :user_id
      t.integer :article_comment_id
      t.timestamps
    end
    add_index :nice_to_article_comments, :user_id
    add_index :nice_to_article_comments, :article_comment_id
    add_index :nice_to_article_comments, [:user_id, :article_comment_id], unique: true
  end
end
