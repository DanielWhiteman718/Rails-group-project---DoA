# == Schema Information
#
# Table name: objectives
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Objective < ApplicationRecord

    audited
    
    # Objective which an Activity can meet. Each objective for a degree program must have
    # one of these as its code
    # Link an activity to an objective by creating an ActivityObjective object

    # Each objective may link to many activities
    has_many :activity_objectives

    # Checks code (eg. LO1) is unique for all objectives
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true

    def display_str
        "#{code} - #{name}"
    end

end
