# == Schema Information
#
# Table name: activity_teachings
#
#  id                :bigint           not null, primary key
#  g_drive_link      :string
#  mole_pub_link     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activity_id       :bigint           not null
#  resit_priority_id :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_activity_teachings_on_activity_id  (activity_id)
#  index_activity_teachings_on_user_id      (user_id)
#

FactoryBot.define do
  factory :activity_teaching do
    g_drive_link {"https://link.com/ornredew"}
    mole_pub_link {"https://link.com/ivbweohcb"}
  end
end
