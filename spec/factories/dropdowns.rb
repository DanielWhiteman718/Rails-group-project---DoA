# == Schema Information
#
# Table name: dropdowns
#
#  id           :bigint           not null, primary key
#  display_name :string
#  drop_down    :string
#  value        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_dropdowns_on_drop_down  (drop_down)
#  index_dropdowns_on_value      (value)
#

FactoryBot.define do
  factory :dropdown do
    display_name { "MyString" }
    drop_down { "MyString" }
    value { "MyString" }
  end
end
