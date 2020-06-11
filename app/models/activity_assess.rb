# == Schema Information
#
# Table name: activity_assesses
#
#  id                    :bigint           not null, primary key
#  assess_weight         :float
#  notes                 :text
#  num_assess            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  activity_id           :bigint           not null
#  during_assess_type_id :bigint
#  post_assess_type_id   :bigint
#  post_lab_type_id      :bigint
#  pre_assess_type_id    :bigint
#
# Indexes
#
#  index_activity_assesses_on_activity_id  (activity_id)
#

class ActivityAssess < ApplicationRecord

    audited

    # activity_id is the foreign key for the activity that this info belongs to
    belongs_to :activity, optional: true

    # Pre, during, post assessment drop down
    belongs_to :pre_assess_type, :class_name => 'Dropdown', foreign_key: 'pre_assess_type_id', optional: true
    belongs_to :during_assess_type, :class_name => 'Dropdown', foreign_key: 'during_assess_type_id', optional: true
    belongs_to :post_assess_type, :class_name => 'Dropdown', foreign_key: 'post_assess_type_id', optional: true
    # Post lab type drop down
    belongs_to :post_lab_type, :class_name => 'Dropdown', foreign_key: 'post_lab_type_id', optional: true

    # Checks assessment weight is between 0 and 100 percent + num assess >= 0
    validates_with ActivityAssessValidator

end
