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

FactoryBot.define do
  factory :room do
    code {1.01}
    name {'Test Room'}
  end
end
