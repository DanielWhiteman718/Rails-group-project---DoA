# == Schema Information
#
# Table name: activity_teches
#
#  id               :bigint           not null, primary key
#  cost_per_student :float
#  equip_needed     :text
#  last_risk_assess :date
#  next_risk_assess :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activity_id      :bigint           not null
#  tech_lead_id     :bigint
#  tech_ustudy_id   :bigint
#
# Indexes
#
#  index_activity_teches_on_activity_id     (activity_id)
#  index_activity_teches_on_tech_lead_id    (tech_lead_id)
#  index_activity_teches_on_tech_ustudy_id  (tech_ustudy_id)
#

class ActivityTech < ApplicationRecord

    audited
    
    belongs_to :activity, optional: true
    # Two users are linked from this class:
    # Technical lead is the user in charge of technical details for the activity
    belongs_to :tech_lead, :class_name => "User", foreign_key: "tech_lead_id", optional: true
    # Technical understudy is who takes over if the tech lead is not available
    belongs_to :tech_ustudy, :class_name => "User", foreign_key: "tech_ustudy_id", optional: true

    # Checks cost per student is not below 0
    validates_with ActivityTechValidator

end
