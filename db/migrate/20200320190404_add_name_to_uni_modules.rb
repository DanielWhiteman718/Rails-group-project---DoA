class AddNameToUniModules < ActiveRecord::Migration[6.0]
  def change
    add_column :uni_modules, :name, :string
  end
end
