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

FactoryBot.define do
  factory :objective do
    code {'T1'}
    name {'Test Objective 1'}
  end
end
