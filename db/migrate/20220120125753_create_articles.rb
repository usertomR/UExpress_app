class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :accuracy_text
      t.integer :difficultylevel_text
      t.text :articletext
      t.boolean :Eschool_level, default: false
      t.boolean :JHschool_level, default: false
      t.boolean :Hschool_level, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # user_idに関連付けられたすべての記事を更新時刻の逆順で取り出しやすくなる。
    # URL: https://stackoverflow.com/questions/14844780/what-is-a-multiple-key-index
    add_index :articles, [:user_id, :updated_at]
  end
end
