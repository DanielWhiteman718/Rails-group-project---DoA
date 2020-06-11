# == Schema Information
#
# Table name: programmes
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Programme < ApplicationRecord

    audited
    
    # Model for a degree programme. Not linked to a module

    # Each programme has many activities
    has_many :activity_programmes
    has_many :activities, through: :activity_programmes

    # Each programme is associated with many activity_objectives
    has_many :activity_objectives

    # Each degree programme needs a unique identifying code and a name
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
end
