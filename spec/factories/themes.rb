# == Schema Information
#
# Table name: themes
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :theme do
    code {''}
  end
end
