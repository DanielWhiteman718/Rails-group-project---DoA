class AddCreditsToUniModule < ActiveRecord::Migration[6.0]
  def change
    add_column :uni_modules, :credits, :integer
  end
end
