class AddFewColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :mobile_number, :string
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
  end
end
