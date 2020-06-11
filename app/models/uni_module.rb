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

class UniModule < ApplicationRecord

    audited
    
    # UniModule is the model for modules (the name Module is reserved by Rails)

    # An activity belongs to a module
    has_many :activities
    # This user is the module lead
    belongs_to :user
    # Semester dropdown
    belongs_to :semester, :class_name => 'Dropdown', foreign_key: 'semester_id'

    # A module must have a unique identifying code
    validates :code, presence: true, uniqueness: true
    validates :level, presence: true

    # Checks credits is not negative
    validates :credits, :numericality => { :greater_than_or_equal_to => 0 }

    # Checks level is between 1 and 6
    validates_inclusion_of :level, in: 1..6

end
