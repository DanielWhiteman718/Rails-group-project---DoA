# == Schema Information
#
# Table name: activity_gta
#
#  id           :bigint           not null, primary key
#  criteria     :text
#  job_desc     :text
#  jobshop_desc :text
#  marking_time :integer
#  staff_ratio  :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :bigint           not null
#
# Indexes
#
#  index_activity_gta_on_activity_id  (activity_id)
#

class ActivityGta < ApplicationRecord

    audited
    has_associated_audits
    
    # Staff ratio is the number of students to one staff member

    belongs_to :activity, optional: true

    # A GTA invite is an invite to a member of staff (user)
    # There may be 0 to many of them for any activity
    has_many :gta_invites, dependent: :destroy
    accepts_nested_attributes_for :gta_invites, allow_destroy: true, :reject_if => lambda { |a| a[:content].blank? }

    validates_with ActivityGtaValidator

end
