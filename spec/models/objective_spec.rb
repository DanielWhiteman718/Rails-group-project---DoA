# == Schema Information
#
# Table name: objectives
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Objective, type: :model do

  it 'is valid with valid attributes' do
    o = FactoryBot.build(:objective)
    expect(o).to be_valid
  end

  it 'is invalid with blank attributes' do
    o = Objective.new
    expect(o).to_not be_valid
  end

  it 'is invalid with a non-unique code' do
    o = FactoryBot.create(:programme)
    o2 = FactoryBot.build(:programme, name: 'Something different')
    expect(o).to be_valid
    expect(o2).to_not be_valid
  end

  describe '#display_str' do
    it 'returns the code and name of the objective' do
      o = FactoryBot.build(:objective)
      expected = "#{o.code} - #{o.name}"
      expect(o.display_str).to eq expected
    end
  end
end
