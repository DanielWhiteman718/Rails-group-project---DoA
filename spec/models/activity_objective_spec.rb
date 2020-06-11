# == Schema Information
#
# Table name: activity_objectives
#
#  id           :bigint           not null, primary key
#  long_desc    :string
#  short_desc   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  objective_id :bigint
#
# Indexes
#
#  index_activity_objectives_on_objective_id  (objective_id)
#

require 'rails_helper'

RSpec.describe ActivityObjective, type: :model do
  it 'is valid with valid attributes' do
    o = FactoryBot.create(:objective)
    pr = FactoryBot.create(:programme)
    ao = FactoryBot.build(:activity_objective, objective_id: o.id, programme_id: pr.id)
    expect(ao).to be_valid
  end

  it 'is invalid with blank attributes' do
    ao = ActivityObjective.new
    expect(ao).to_not be_valid
  end

  it 'is invalid without an objective_id' do
    pr = FactoryBot.create(:programme)
    ao = FactoryBot.build(:activity_objective, programme_id: pr.id)
    expect(ao).to_not be_valid
  end

  it 'is invalid without a short description' do
    o = FactoryBot.create(:objective)
    pr = FactoryBot.create(:programme)
    ao = FactoryBot.build(:activity_objective, objective_id: o.id, programme_id: pr.id, short_desc: nil)
    expect(ao).to_not be_valid
  end

  it 'is invalid without a programme_id' do
    o = FactoryBot.create(:objective)
    ao = FactoryBot.build(:activity_objective, objective_id: o.id)
    expect(ao).to_not be_valid
  end

  describe '#display_str' do
    it 'outputs the objective code and short description of a learning objective' do
      o = FactoryBot.create(:objective)
      ao = FactoryBot.build(:activity_objective, objective_id: o.id)
      expected = "#{o.code} - #{ao.short_desc}"
      expect(ao.display_str).to eq expected
    end
  end
end
