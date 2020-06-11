class AddNewValToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :edit_requests, :new_val, :string
  end
end
