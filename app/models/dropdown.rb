# == Schema Information
#
# Table name: dropdowns
#
#  id           :bigint           not null, primary key
#  display_name :string
#  drop_down    :string
#  value        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_dropdowns_on_drop_down  (drop_down)
#  index_dropdowns_on_value      (value)
#
class Dropdown < ApplicationRecord

    audited only: :value

    def self.get_collection(drop_down)
        return Dropdown.select(:id, :value).where(drop_down: drop_down)
    end

    # Semester
    has_many :uni_modules, :class_name => 'UniModule', :foreign_key => 'semester_id'

    # Pre, during, post assessment
    has_many :activity_assesses, :class_name => 'ActivityAssess', :foreign_key => 'pre_assess_type_id'
    has_many :activity_assesses, :class_name => 'ActivityAssess', :foreign_key => 'during_assess_type_id'
    has_many :activity_assesses, :class_name => 'ActivityAssess', :foreign_key => 'post_assess_type_id'

    # Post lab type
    has_many :activity_assesses, :class_name => 'ActivityAssess', :foreign_key => 'post_lab_type_id'

    # Resit priority
    has_many :activity_teachings, :class_name => 'ActivityTeaching', :foreign_key => 'resit_priority_id'

    validates :display_name, :drop_down, :value, presence: true
end
