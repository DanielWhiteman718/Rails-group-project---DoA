# == Schema Information
#
# Table name: themes
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Theme, type: :model do
  it 'is valid with valid attributes' do
    t = Theme.new(code: 'ACME')
    expect(t).to be_valid
  end

  it 'is invalid with blank attributes' do
    t = Theme.new
    expect(t).to_not be_valid
  end

  it 'must have a unique code' do
    t = Theme.create(code: 'ACME')
    t2 = Theme.new(code: 'ACME')
    expect(t).to be_valid
    expect(t2).to_not be_valid
  end
end
