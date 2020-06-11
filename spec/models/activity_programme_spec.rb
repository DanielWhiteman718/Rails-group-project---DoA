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

require 'rails_helper'

RSpec.describe ActivityProgramme, type: :model do
  it 'is valid with valid attributes' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    p = FactoryBot.create(:programme)
    ap = ActivityProgramme.new(activity_id: a.id, programme_id: p.id)
    expect(ap).to be_valid
  end

  it 'is invalid with blank attributes' do
    ap = ActivityProgramme.new
    expect(ap).to_not be_valid
  end
end
