class CreateActivityProgrammes < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_programmes do |t|
      t.belongs_to :activity, :null => false
      t.belongs_to :programme, :null => false
      t.timestamps
    end
  end
end
