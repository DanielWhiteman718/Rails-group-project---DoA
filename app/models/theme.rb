# == Schema Information
#
# Table name: themes
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Theme < ApplicationRecord

    audited
    
    # Each activity belongs to a theme
    has_many :activities
    # A theme can be uniquely identified by its code
    validates :code, presence: true, uniqueness: true
end
