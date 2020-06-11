# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Room, type: :model do

  it 'is valid with valid attributes' do
    r = FactoryBot.build(:room)
    expect(r).to be_valid
  end

  it 'is invalid with blank attributes' do
    r = Room.new
    expect(r).to_not be_valid
  end

  it 'is invalid with no room code' do
    r = FactoryBot.build(:room, code: '')
    expect(r).to_not be_valid
  end

  it 'is invalid with no room name' do
    r = FactoryBot.build(:room, name: '')
  end

  it 'must have a unique room code' do
    r = FactoryBot.create(:room)
    r2 = FactoryBot.build(:room, name: 'Something different')
    expect(r).to be_valid
    expect(r2).to_not be_valid
  end

  it 'must have a unique name' do
    r = FactoryBot.create(:room)
    r2 = FactoryBot.build(:room, code: '1.02')
    expect(r).to be_valid
    expect(r2).to_not be_valid
  end

  describe '#display_str' do
    it 'outputs the name and code of the room' do
      r = FactoryBot.build(:room)
      expected = "#{r.name} (#{r.code})"
      expect(r.display_str).to eq expected
    end
  end
end
