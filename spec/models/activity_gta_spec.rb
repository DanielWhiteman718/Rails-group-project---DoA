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

require 'rails_helper'

RSpec.describe ActivityGta, type: :model do
  it 'is valid with valid attributes' do
    gta = FactoryBot.build(:activity_gta)
    expect(gta).to be_valid
  end

  it 'is valid with blank attributes' do
    gta = ActivityGta.new
    expect(gta).to be_valid
  end

  it 'is invalid with a negative marking time' do
    gta = FactoryBot.build(:activity_gta)
    # Default marking time is 20
    expect(gta).to be_valid
    gta.marking_time = 0
    expect(gta).to be_valid
    gta.marking_time = -1
    expect(gta).to_not be_valid
  end

  it 'is invalid with a staff per student ratio <= 0' do
    gta = FactoryBot.build(:activity_gta)
    # Default staff ratio is 12
    expect(gta).to be_valid
    gta.staff_ratio = 0.1
    expect(gta).to be_valid
    gta.staff_ratio = 0
    expect(gta).to_not be_valid
  end
end
