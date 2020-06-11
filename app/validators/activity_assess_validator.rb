class ActivityAssessValidator < ActiveModel::Validator
    def validate(assess)
        # Assessment weight must be between 0 and 100
        unless assess.assess_weight.nil?
            unless assess.assess_weight.between?(0, 100)
                assess.errors[:assess_weight] << 'must be between 0 and 100'
            end
        end

        # Num assessments must be 0 or more
        unless assess.num_assess.nil?
            if assess.num_assess < 0
                assess.errors[:num_assess] << 'must be 0 or higher'
            end
        end
    end
end