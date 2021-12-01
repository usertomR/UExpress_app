class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email, unique: true # emailの一意性をDBレベルで強制
  end
end
