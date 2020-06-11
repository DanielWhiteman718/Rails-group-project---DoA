# == Schema Information
#
# Table name: programmes
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Programme, type: :model do
  it 'is valid with valid attributes' do
    p = FactoryBot.build(:programme)
    expect(p).to be_valid
  end

  it 'is invalid with blank attributes' do
    p = Programme.new
    expect(p).to_not be_valid
  end

  it 'is invalid with no code' do
    p = FactoryBot.build(:programme, code: '')
    expect(p).to_not be_valid
  end

  it 'is invalid with no name' do
    p = FactoryBot.build(:programme, name: '')
    expect(p).to_not be_valid
  end

  it 'is invalid with a non-unique code' do
    p = FactoryBot.create(:programme)
    p2 = FactoryBot.build(:programme, name: 'Something different')
    expect(p).to be_valid
    expect(p2).to_not be_valid
  end
end
