# == Schema Information
#
# Table name: activity_assesses
#
#  id                    :bigint           not null, primary key
#  assess_weight         :float
#  notes                 :text
#  num_assess            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  activity_id           :bigint           not null
#  during_assess_type_id :bigint
#  post_assess_type_id   :bigint
#  post_lab_type_id      :bigint
#  pre_assess_type_id    :bigint
#
# Indexes
#
#  index_activity_assesses_on_activity_id  (activity_id)
#

require 'rails_helper'

RSpec.describe ActivityAssess, type: :model do
  
  it 'is valid with valid attributes' do
    p2p = Dropdown.create(drop_down: "assessment", value: "Pass to progress", display_name: "Assessment type")
    post_mole = Dropdown.create(drop_down: "post_lab", value: "MOLE MCQ", display_name: "Post lab assessment type")
    aa = FactoryBot.build(:activity_assess, pre_assess_type_id: p2p.id, 
      during_assess_type_id: p2p.id, post_assess_type_id: p2p.id, post_lab_type_id: post_mole.id)
    expect(aa).to be_valid
  end

  it 'is valid with empty attributes' do
    aa = ActivityAssess.new
    expect(aa).to be_valid
  end

  it 'is invalid if the number of assessments is negative' do
    aa = FactoryBot.build(:activity_assess)
    # Default num_assess is 2
    expect(aa).to be_valid
    aa.num_assess = 0
    expect(aa).to be_valid
    aa.num_assess = -1
    expect(aa).to_not be_valid
  end

  it 'is invalid if the assessment weight is below 0 or above 100' do
    aa = FactoryBot.build(:activity_assess, assess_weight: 0)
    expect(aa).to be_valid
    aa.assess_weight = -1
    expect(aa).to_not be_valid
    aa.assess_weight = 100
    expect(aa).to be_valid
    aa.assess_weight = 101
    expect(aa).to_not be_valid
  end

end
