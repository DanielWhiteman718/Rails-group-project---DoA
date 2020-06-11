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

FactoryBot.define do
  factory :activity_gta, class: 'ActivityGta' do
    criteria {"Criteria blah blah blah"}
    job_desc {"Job Description blah blah blah"}
    jobshop_desc {"Jobshop Entry blah blah blah"}
    marking_time {20}
    staff_ratio {12}
  end
end
