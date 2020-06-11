# == Schema Information
#
# Table name: activity_objectives
#
#  id           :bigint           not null, primary key
#  long_desc    :string
#  short_desc   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  objective_id :bigint
#
# Indexes
#
#  index_activity_objectives_on_objective_id  (objective_id)
#

class ActivityObjective < ApplicationRecord
    
    audited
    has_associated_audits
    
    # activity_id links to the parent activity
    has_many :objective_linkers
    has_many :activities, through: :objective_linkers
    # objective_id links to the objective code the activity assesses
    belongs_to :objective

    def display
        return "#{objective.display_str}: #{short_desc}"
    end
    # Each objective has one degree programme it applies to
    belongs_to :programme

    validates :short_desc, presence: true

    # Outputs code and short desc
    def display_str
        "#{objective.code} - #{short_desc}"
    end

end
