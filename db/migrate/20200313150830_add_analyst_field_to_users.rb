class AddAnalystFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :analyst, :boolean
  end
end
