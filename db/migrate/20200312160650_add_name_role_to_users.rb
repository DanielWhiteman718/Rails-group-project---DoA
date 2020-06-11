class AddNameRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string
    add_column :users, :role, :integer
  end
end
