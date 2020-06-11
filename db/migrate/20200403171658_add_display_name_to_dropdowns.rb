class AddDisplayNameToDropdowns < ActiveRecord::Migration[6.0]
  def change
    add_column :dropdowns, :display_name, :string
  end
end
