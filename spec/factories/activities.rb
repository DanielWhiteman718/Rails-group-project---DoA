# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  archived      :boolean          default(FALSE), not null
#  code          :string           not null
#  in_drive      :boolean          default(FALSE), not null
#  name          :string           not null
#  name_abrv     :string
#  notes         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  theme_id      :bigint           not null
#  uni_module_id :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_activities_on_theme_id                             (theme_id)
#  index_activities_on_theme_id_and_code_and_uni_module_id  (theme_id,code,uni_module_id) UNIQUE
#  index_activities_on_uni_module_id                        (uni_module_id)
#  index_activities_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :activity do
    code {'111b'}
    name {'Test Activity'}
    in_drive {true}
    archived {false}
  end
end
