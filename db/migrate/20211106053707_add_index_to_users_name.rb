class AddIndexToUsersName < ActiveRecord::Migration[6.0]
  def change
    add_index :users,:name,unique:true  #nameの一意性をDBレベルで強制
  end
end
