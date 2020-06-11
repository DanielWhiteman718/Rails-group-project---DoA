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

class User < ApplicationRecord
  include EpiCas::DeviseHelper

  audited only: [:analyst, :display_name, :email, :role, :super_user]

  # Enums for user role
  @@ADMIN = 0
  @@TECH = 1
  @@ACAD = 2

  # Accessors for user role enums
  def self.admin_id
    return @@ADMIN
  end

  def self.tech_id
    return @@TECH
  end

  def self.acad_id
    return @@ACAD
  end

  # Hash to convert role enum to displayable text
  @@ROLE_STRINGS = {
    @@ACAD => "Academic",
    @@ADMIN => "Administrative",
    @@TECH => "Technical"
  }

  def self.role_strings
    @@ROLE_STRINGS
  end
  
  # Checks email is given and is unique
  validates :email, presence: true, uniqueness: true
  # Checks a display name is given
  validates :display_name, presence: true

  # Checks analyst and super user booleans are either true or false
  # 'presence:' validator does not work on booleans
  validates :analyst, inclusion: {in: [true, false]}
  validates :super_user, inclusion: {in: [true, false]}

  # Checks email is valid and belongs to uni
  validates_with UserValidator

  # MEE Lead
  has_many :themes
  # Module Lead
  has_many :uni_modules
  # Teaching Understudy
  has_many :activity_teaching
  
  # Tech Lead
  has_many :tech_leads, :class_name => 'User', :foreign_key => 'tech_lead_id'
  # Tech understudy
  has_many :tech_ustudies, :class_name => 'User', :foreign_key => 'tech_ustudy_id'

  # GTA Invites
  has_many :gta_invites

  # Activity change requests
  # Initiator sends the request
  has_many :initiators, :class_name => 'User', :foreign_key => 'initiator'
  # Target receives the request
  has_many :targets, :class_name => 'User', :foreign_key => 'target'

  # Stuff from Devise for authentication, keep commented out
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
end
