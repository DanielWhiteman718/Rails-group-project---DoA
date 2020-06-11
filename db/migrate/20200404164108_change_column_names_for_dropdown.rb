class ChangeColumnNamesForDropdown < ActiveRecord::Migration[6.0]
  def change
    # Semester
    remove_column :activities, :semester, :integer
    add_column :activities, :semester_id, :bigint

    # Pre Assess Type
    remove_column :activity_assesses, :pre_assess_type, :integer
    add_column :activity_assesses, :pre_assess_type_id, :bigint
    # During Assess Type
    remove_column :activity_assesses, :during_assess_type, :integer
    add_column :activity_assesses, :during_assess_type_id, :bigint
    # Post Assess Type
    remove_column :activity_assesses, :post_assess_type, :integer
    add_column :activity_assesses, :post_assess_type_id, :bigint
    # Post Lab Type
    remove_column :activity_assesses, :post_lab_type, :integer
    add_column :activity_assesses, :post_lab_type_id, :bigint

    # Pre Assess Type
    remove_column :activity_teachings, :resit_priority, :integer
    add_column :activity_teachings, :resit_priority_id, :bigint
  end
end
