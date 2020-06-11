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

require 'rails_helper'

RSpec.describe ActivityTeaching, type: :model do
  it 'is valid with valid attributes' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    r = Dropdown.create(drop_down: "resit", value: "Low", display_name: "Resit priority")
    at = FactoryBot.create(:activity_teaching, activity_id: a.id, resit_priority_id: r.id, user_id: u.id)
    expect(at).to be_valid
  end

  it 'is valid with blank attributes' do
    at = ActivityTeaching.new
    expect(at).to be_valid
  end

end
