# == Schema Information
#
# Table name: activity_assesses
#
#  id                    :bigint           not null, primary key
#  assess_weight         :float
#  notes                 :text
#  num_assess            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  activity_id           :bigint           not null
#  during_assess_type_id :bigint
#  post_assess_type_id   :bigint
#  post_lab_type_id      :bigint
#  pre_assess_type_id    :bigint
#
# Indexes
#
#  index_activity_assesses_on_activity_id  (activity_id)
#

FactoryBot.define do
  factory :activity_assess do
    assess_weight {50}
    num_assess {2}
    notes {"Assessment notes"}
  end
end
