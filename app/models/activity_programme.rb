# == Schema Information
#
# Table name: activity_programmes
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :bigint           not null
#  programme_id :bigint           not null
#
# Indexes
#
#  index_activity_programmes_on_activity_id   (activity_id)
#  index_activity_programmes_on_programme_id  (programme_id)
#

class ActivityProgramme < ApplicationRecord

    audited
    
    belongs_to :activity
    belongs_to :programme
end
