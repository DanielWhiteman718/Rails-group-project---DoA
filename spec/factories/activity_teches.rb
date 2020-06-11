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

FactoryBot.define do
  factory :activity_tech do
    cost_per_student {2.50}
    equip_needed {"Hammer, Saw, Particle Accelerator"}
    last_risk_assess {Date.new(2019, 4, 15)}
    next_risk_assess {Date.new(2021, 4, 15)}
  end
end
