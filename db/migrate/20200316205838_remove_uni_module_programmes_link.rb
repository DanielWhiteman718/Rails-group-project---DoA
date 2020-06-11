class RemoveUniModuleProgrammesLink < ActiveRecord::Migration[6.0]
  def change
    remove_column :programmes, :uni_module_id
    add_column :programmes, :name, :string
  end
end
