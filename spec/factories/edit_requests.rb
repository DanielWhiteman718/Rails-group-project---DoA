# == Schema Information
#
# Table name: edit_requests
#
#  id           :bigint           not null, primary key
#  message      :text
#  new_val      :string
#  status       :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :bigint
#  bulk_id      :integer
#  column_id    :bigint
#  initiator_id :bigint
#  target_id    :bigint
#
# Indexes
#
#  index_edit_requests_on_activity_id   (activity_id)
#  index_edit_requests_on_column_id     (column_id)
#  index_edit_requests_on_initiator_id  (initiator_id)
#  index_edit_requests_on_target_id     (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (column_id => columns.id)
#

FactoryBot.define do
    factory :edit_request do
      message {'Test message'}
      status {0}
      title {'Test title'}
    end
  end