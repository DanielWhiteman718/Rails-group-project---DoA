# == Schema Information
#
# Table name: gta_invites
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  activity_gta_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_gta_invites_on_activity_gta_id  (activity_gta_id)
#  index_gta_invites_on_user_id          (user_id)
#

# Invites a member of staff as a GTA person for an activity
# We just have to store these invites
class GtaInvite < ApplicationRecord

    audited
    audited associated_with: :activity_gta
    
    # Belongs to an activity's GTA info section
    belongs_to :activity_gta, optional: true
    
    # Links to one user who is invited
    belongs_to :user

end
