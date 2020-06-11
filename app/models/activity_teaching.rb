# == Schema Information
#
# Table name: activity_teachings
#
#  id                :bigint           not null, primary key
#  g_drive_link      :string
#  mole_pub_link     :string
#  resit_priority_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activity_id       :bigint           not null
#  user_id           :bigint
#
# Indexes
#
#  index_activity_teachings_on_activity_id  (activity_id)
#  index_activity_teachings_on_user_id      (user_id)
#

class ActivityTeaching < ApplicationRecord

    audited
    
    belongs_to :activity, optional: true
    # user_id is the understudy id
    belongs_to :user, optional: true
    # Resit priority drop down
    belongs_to :resit_priority, :class_name => 'Dropdown', foreign_key: 'resit_priority_id', optional: true

end
