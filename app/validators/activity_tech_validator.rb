class ActivityTechValidator < ActiveModel::Validator
    
    def validate(tech)
        unless tech.cost_per_student.nil?
            if tech.cost_per_student < 0
                tech.errors[:cost_per_student] << "must be positive"
            end
        end
    end
end