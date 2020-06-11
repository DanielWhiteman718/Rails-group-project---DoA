class CreateGtaInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :gta_invites do |t|
      t.belongs_to :activity_gta
      t.belongs_to :user
      t.timestamps
    end
  end
end
