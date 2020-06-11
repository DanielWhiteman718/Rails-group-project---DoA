class AddFieldNameToRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :edit_requests, :column, foreign_key: true
  end
end
