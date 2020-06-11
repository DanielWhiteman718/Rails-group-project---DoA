class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :edit_requests do |t|
      t.belongs_to :activity
      # Person sending request
      t.references :initiator
      # Person receiving request
      t.references :target
      t.string :title
      t.text :message
      t.timestamps
    end
  end
end
