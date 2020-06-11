# == Schema Information
#
# Table name: uni_modules
#
#  id          :bigint           not null, primary key
#  code        :string           not null
#  credits     :integer
#  level       :integer          not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  semester_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_uni_modules_on_code         (code)
#  index_uni_modules_on_semester_id  (semester_id)
#  index_uni_modules_on_user_id      (user_id)
#

FactoryBot.define do

  factory :uni_module do
    code {'TST124'}
    name {'Test Module'}
    level {1}
    credits {20}
  end
end
