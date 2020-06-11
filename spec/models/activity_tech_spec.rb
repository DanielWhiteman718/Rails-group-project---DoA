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

require 'rails_helper'

RSpec.describe ActivityTech, type: :model do
  it 'is valid with valid attributes' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    u2 = FactoryBot.create(:user, email: 'djwhiteman1@sheffield.ac.uk', display_name: 'Dan Whiteman')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    at = FactoryBot.build(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u2.id)
    expect(at).to be_valid
  end

  it 'is valid with blank attributes' do
    at = ActivityTech.new
    expect(at).to be_valid
  end

  it 'is invalid with a negative cost-per-student' do
    at = FactoryBot.build(:activity_tech)
    # Default cost is 2.50
    expect(at).to be_valid
    at.cost_per_student = 0
    expect(at).to be_valid
    at.cost_per_student = -1
    expect(at).to_not be_valid
  end
end
