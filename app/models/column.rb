# == Schema Information
#
# Table name: columns
#
#  id           :bigint           not null, primary key
#  db_name      :string
#  display_name :string
#  table        :string
#

class Column < ApplicationRecord
    
    # db_name is the name of the column in the database
    # display_name is the name of the column to display to the user
    # table is the name of the table it is in

    # Returns the type of input required for the field
    def input_type
        # Filters special cases
        # Might change based on how it is being stored
        if db_name == "user_id" && table == "gta_invites" 
            return "gta"
        elsif db_name == "objective_id" && table == "activity_objective" 
            return "objective"
        elsif db_name == "id" && table == "programmes"
            return "programmes"
        elsif db_name == "room_id"
            return "other_rooms"
        end

        case db_name
        when "archived", "same_as_prev_year", "checked_on_timetable", "check"
            return "check"
        when "pref_room_id"
            return "radio"
        when "theme_id", "uni_module_id", "pre_assess_type_id",
            "during_assess_type_id", "post_assess_type_id", "post_lab_type_id",
            "resit_priority_id", "user_id", "tech_lead_id", "tech_ustudy_id",
            "last_risk_assess", "next_risk_assess"    
            return "drop down"
        else
            return "text"    
        end
    end

    def self.columns_for_request(columns)
        cols = []
        columns.each do |col|
            tab = ""
            case col.table
            when "activities"
                case col.db_name
                when "code", "name", "notes", "theme", "user_id"
                    tab = "Activity"
                when "uni_module_id"
                    tab = "Teaching"
                end
            when "activity_assesses"
                case col.db_name
                when "assess_weight", "num_assess", "notes", "post_lab_type_id", 
                    "post_assess_type_id", "during_assess_type_id", "pre_assess_type_id"
                    tab = "Assessment"
                end
            when "activity_gta"
                case col.db_name
                when "criteria", "job_desc", "jobshop_desc", "marking_time", "staff_ratio"
                    tab = "GTA Information"
                end
            when "gta_invites"
                case col.db_name
                when "user_id"
                    tab = "GTA Information"
                end
            when "activity_objective"
                case col.db_name
                when "objective_id"
                    tab = "Learning Outcomes"
                end
            when "activity_teaching"
                case col.db_name
                when "g_drive_link", "mole_pub_link", "user_id", "resit_priority_id"
                    tab = "Teaching"
                end
            when "activity_teches"
                case col.db_name
                when "cost_per_student", "equip_needed", "last_risk_assess", "next_risk_assess",
                    "tech_lead_id", "tech_ustudy_id"
                    tab = "Technical"
                end
            when "activity_timetables"
                case col.db_name
                when "check_on_timetable", "duration", "kit_prep_time", "max_week_num", "min_week_num",
                    "notes", "capacity", "save_as_prev_year", "setup_time", "takedown_time",
                    "series_set_up_time", "pref_room_id"
                    tab = "Timetabling"
                end
            when "room_bookings"
                case col.db_name
                when "room_id"
                    tab = "Timetabling"
                end
            when "programmes"
                case col.db_name
                when "id"
                    tab = "Activity"
                end
            end
            if !tab.empty?
                cols << {id: col.id, display_name: "#{tab} - #{col.display_name}"}
            end
        end
        return cols.sort_by {|c| c[:display_name]}
    end
end
