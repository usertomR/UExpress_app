class CreateArticleBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :article_bookmarks do |t|
      t.integer :user_id
      t.integer :article_id
      t.timestamps
    end
    add_index :article_bookmarks, :user_id
    add_index :article_bookmarks, :article_id
    add_index :article_bookmarks, [:user_id, :article_id], unique: true
  end
end
