class ActivityTimetableValidator < ActiveModel::Validator

    def validate(tt)
        unless tt.duration.nil?
            if tt.duration < 0
                tt.errors[:duration] << "must be positive"
            end
        end

        unless tt.setup_time.nil?
            if tt.setup_time < 0
                tt.errors[:setup_time] << "must be positive"
            end
        end

        unless tt.series_setup_time.nil?
            if tt.series_setup_time < 0
                tt.errors[:series_setup_time] << "must be positive"
            end
        end

        unless tt.takedown_time.nil?
            if tt.takedown_time < 0
                tt.errors[:takedown_time] << "must be positive"
            end
        end

        unless tt.kit_prep_time.nil?
            if tt.kit_prep_time < 0
                tt.errors[:kit_prep_time] << "must be positive"
            end
        end

        unless tt.min_week_num.nil?
            unless tt.min_week_num.between?(1, 40)
                tt.errors[:min_week_num] << "must be positive"
            end
        end

        unless tt.max_week_num.nil?
            unless tt.max_week_num.between?(1, 40)
                tt.errors[:max_week_num] << "must be positive"
            end
        end

        # Check max week num is greater than min week num
        unless tt.min_week_num.nil? || tt.max_week_num.nil?
            if tt.min_week_num > tt.max_week_num
                tt.errors[:min_week_num] << "must be less than max week number"
            end
        end

        unless tt.capacity.nil?
            if tt.capacity < 0
                tt.errors[:capacity] << "must be positive"
            end
        end

    end

end
