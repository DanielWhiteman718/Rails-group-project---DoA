# == Schema Information
#
# Table name: objective_linkers
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  activity_id           :bigint
#  activity_objective_id :bigint
#
# Indexes
#
#  index_objective_linkers_on_activity_id            (activity_id)
#  index_objective_linkers_on_activity_objective_id  (activity_objective_id)
#

FactoryBot.define do
    factory :objective_linker do
      
    end
  end
  