# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  analyst              :boolean          default(FALSE)
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  current_sign_in_ip   :inet
#  display_name         :string
#  dn                   :string
#  email                :string           default(""), not null
#  failed_attempts      :integer          default(0), not null
#  givenname            :string
#  last_sign_in_at      :datetime
#  last_sign_in_ip      :inet
#  locked_at            :datetime
#  mail                 :string
#  ou                   :string
#  role                 :integer
#  sign_in_count        :integer          default(0), not null
#  sn                   :string
#  super_user           :boolean          default(FALSE)
#  uid                  :string
#  unconfirmed_email    :string
#  unlock_token         :string
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email)
#  index_users_on_username  (username)
#

FactoryBot.define do
  factory :user do
    email {''}
    role {0}
    display_name {''}
    super_user {false}
    analyst {false}
  end
end
