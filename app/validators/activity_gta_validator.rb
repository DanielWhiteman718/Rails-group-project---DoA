class ActivityGtaValidator < ActiveModel::Validator

    def validate(gta)
        # Check marking time is positive if not empty
        unless gta.marking_time.nil?
            if gta.marking_time < 0
                gta.errors[:marking_time] << 'cannot be negative'
            end
        end

        # Check staff ratio is positive if not empty
        unless gta.staff_ratio.nil?
            if gta.staff_ratio <= 0
                gta.errors[:staff_ratio] << 'must be greater than 0'
            end
        end
    end

end