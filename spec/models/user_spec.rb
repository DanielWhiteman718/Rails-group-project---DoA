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

require 'rails_helper'

# Note: these tests cannot test whether User's email must belong to the university
# because the get_info_from_ldap method always returns nil in a testing environment
RSpec.describe User, type: :model do

  it 'it valid when all required attributes are valid' do
    u = FactoryBot.build(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    expect(u).to be_valid
  end

  it 'is invalid with no attributes' do
    u = User.new
    expect(u).to_not be_valid
  end

  it 'is invalid with an invalid email address' do
    u = FactoryBot.build(:user, email: '@ienimmk...1049u', display_name: 'Dan Perry')
    expect(u).to_not be_valid
  end

  it 'is invalid with a non-unique email address' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    u2 = FactoryBot.build(:user, email: 'dperry1@sheffield.ac.uk', display_name: "Dan't Perry")
    expect(u).to be_valid
    expect(u2).to_not be_valid
  end

  it "is invalid with no email" do
    u = User.new(display_name: 'Dan Perry', role: 0, super_user: true, analyst: false)
    expect(u).to_not be_valid
  end

  it 'is invalid when the boolean values super_user and analyst are nil' do
    u = User.new(display_name: 'Dan Perry', email: 'dperry1@sheffield.ac.uk', role: 0)
  end

end
