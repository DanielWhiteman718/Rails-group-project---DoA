class AddFieldsToActivity < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :name_abrv, :string
    add_column :activities, :semester, :integer

  end
end
