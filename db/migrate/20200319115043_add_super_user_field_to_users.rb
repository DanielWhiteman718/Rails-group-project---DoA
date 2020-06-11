class AddSuperUserFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :super_user, :boolean
  end
end
