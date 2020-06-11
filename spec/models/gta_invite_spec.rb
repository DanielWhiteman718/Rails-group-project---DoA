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

require 'rails_helper'

RSpec.describe GtaInvite, type: :model do
  it 'is invalid with blank attributes' do
    gta = GtaInvite.new
    expect(gta).to_not be_valid
  end
end
