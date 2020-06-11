class AddFieldsToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :edit_requests, :bulk_id, :integer
    add_column :edit_requests, :status, :integer
  end
end
