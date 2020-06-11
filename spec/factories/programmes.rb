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

FactoryBot.define do
  factory :programme do
    code {'TEST'}
    name {'Test Programme'}
  end
end
