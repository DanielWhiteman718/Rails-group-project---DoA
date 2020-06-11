class AddUserReferenceToActivity < ActiveRecord::Migration[6.0]
  def change
    change_table :uni_modules do |t|
      t.belongs_to :user
    end
  end
end
