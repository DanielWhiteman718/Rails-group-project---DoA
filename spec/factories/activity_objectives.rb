# == Schema Information
#
# Table name: activity_objectives
#
#  id           :bigint           not null, primary key
#  long_desc    :string
#  short_desc   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  objective_id :bigint
#
# Indexes
#
#  index_activity_objectives_on_objective_id  (objective_id)
#

FactoryBot.define do
  factory :activity_objective do
    short_desc {"Blah"}
    long_desc {"Blah blah blah blah"}
  end
end
