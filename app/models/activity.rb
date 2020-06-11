# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  archived      :boolean          default(FALSE), not null
#  code          :string           not null
#  in_drive      :boolean          default(FALSE), not null
#  name          :string           not null
#  name_abrv     :string
#  notes         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  theme_id      :bigint           not null
#  uni_module_id :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_activities_on_theme_id                             (theme_id)
#  index_activities_on_theme_id_and_code_and_uni_module_id  (theme_id,code,uni_module_id) UNIQUE
#  index_activities_on_uni_module_id                        (uni_module_id)
#  index_activities_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Activity < ApplicationRecord

    audited
    
    # Outputs activities to a CSV file for legacy systems
    def self.to_csv
        # Array of headers
        # In the same order as the old spreadsheet, do not change
        attrs = %w(Unique\ ID Theme Activity\ Name Abbrieviated\ Name Module\ Code 
            Module\ Level Semester Degree\ Programmes MEE\ Lead Module\ Lead In\ Drive? 
            Archived? General\ Notes Understudy MOLE_PUBLIC\ Link G\ Drive\ Link 
            Resit\ Priority Same\ As\ Last\ Year? Checked\ On\ Timetable? Minimum\ Week\ Number 
            Maximum\ Week\ Number Duration\ (minutes) Initial\ Setup\ Time\ (minutes) Capacity
            Takedown\ Time\ (minutes) Series\ Setup\ Time\ (minutes) Kit\ Preparation\ Time\ (minutes) 
            Preferred\ Room Other\ Rooms Timetabling\ Notes GTA\ to\ Student\ Ratio 
            Marking\ Time\ (minutes\ per\ student) Job\ Description GTA\ Skills\ Required 
            GTA\ Invites Jobshop\ Booking Module\ Credits Number\ Of\ Assessments Pre-assessment\ Type 
            During-assessment\ Type Post-assessment\ Type Post-lab\ Type Assessment\ Weight\ (%) 
            Assessment\ Notes Lead\ Technician Technical\ Understudy Last\ Risk\ Assessment\ Date 
            Next\ Risk\ Assessment\ Date Equipment\ Needed Cost\ Per\ Student\ (£) Objectives)
        CSV.generate(headers: true) do |csv|
            # Append headers to CSV
            csv << attrs
            # Append each actvity's attributes to the CSV file
            all.each do |a|
                # Have to generate list of GTA invites here so commas are escaped
                gta_str = ""
                a.activity_gta.gta_invites.each do |inv|
                    gta_str << "#{inv.user.email}, "
                end
                gta_str = gta_str.delete_suffix(', ')

                # Deal with possible nil for association values which may not exist
                pre_assess = a.activity_assess.pre_assess_type
                pre_assess_str = pre_assess.nil? ? "" : pre_assess.value

                during_assess = a.activity_assess.during_assess_type
                during_assess_str = during_assess.nil? ? "" : during_assess.value

                post_assess = a.activity_assess.post_assess_type
                post_assess_str = post_assess.nil? ? "" : post_assess.value

                post_lab = a.activity_assess.post_lab_type
                post_lab_str = post_lab.nil? ? "" : post_lab.value

                tech_lead = a.activity_tech.tech_lead
                tech_lead_str = tech_lead.nil? ? "" : tech_lead.display_name

                tech_ustudy = a.activity_tech.tech_ustudy
                tech_ustudy_str = tech_ustudy.nil? ? "" : tech_ustudy.display_name

                pref_room = a.activity_timetable.pref_room
                pref_room_str = pref_room.nil? ? "" : pref_room.display_str

                objectives_str = ""
                a.activity_objectives.each do |a_obj|
                    obj = a_obj.objective
                    objectives_str << "#{obj.code} #{obj.name} - #{a_obj.short_desc}, "
                end
                objectives_str = objectives_str.delete_suffix(', ')

                # Append all attributes to the csv file, automatically inserts commas
                csv << [a.unique_id, a.theme.code, a.name, a.name_abrv, a.uni_module.code, a.uni_module.level,
                    a.uni_module.semester.value, a.degree_string, a.user.display_name, a.uni_module.user.display_name,
                    a.in_drive ? "Y" : "N", a.archived ? "Y" : "N", a.notes, a.activity_teaching.user.display_name,
                    a.activity_teaching.mole_pub_link, a.activity_teaching.g_drive_link, a.activity_teaching.resit_priority.value,
                    a.activity_timetable.same_as_prev_year ? "Y" : "N", a.activity_timetable.checked_on_timetable ? "Y" : "N",
                    a.activity_timetable.min_week_num, a.activity_timetable.max_week_num, a.activity_timetable.duration,
                    a.activity_timetable.setup_time, a.activity_timetable.takedown_time, a.activity_timetable.series_setup_time,
                    a.activity_timetable.kit_prep_time, a.activity_timetable.capacity, pref_room_str, a.activity_timetable.other_room_str,
                    a.activity_timetable.notes, a.activity_gta.staff_ratio, a.activity_gta.marking_time,
                    a.activity_gta.job_desc, a.activity_gta.criteria, gta_str, a.activity_gta.jobshop_desc,
                    a.uni_module.credits, a.activity_assess.num_assess, pre_assess_str, during_assess_str,
                    post_assess_str, post_lab_str, a.activity_assess.assess_weight, a.activity_assess.notes,
                    tech_lead_str, tech_ustudy_str, a.activity_tech.last_risk_assess,
                    a.activity_tech.next_risk_assess, a.activity_tech.equip_needed, a.activity_tech.cost_per_student,
                    objectives_str]
            end
        end
    end

    # Creates a CSV version of the attributes needed for lab book info
    # exporting to legacy systems
    def self.lab_book_csv
        attrs = %w(Unique\ ID Activity\ Name Module\ Code Module\ Level Semster Degree\ Programmes)
        CSV.generate(headers: true) do |csv|
            csv << attrs
            all.each do |a|
                csv << [a.unique_id, a.name, a.uni_module.code, a.uni_module.level, a.uni_module.semester.value,
                    a.degree_string]
            end
        end
    end

    # References a theme and a module which the activity belongs to
    belongs_to :theme
    belongs_to :uni_module
    accepts_nested_attributes_for :uni_module, :reject_if => lambda { |a| a[:content].blank? }
    # Has a user as the MEE Lead
    belongs_to :user, optional: true

    # Activity will always have one of these for additional details
    has_one :activity_timetable, dependent: :destroy
    accepts_nested_attributes_for :activity_timetable, :reject_if => lambda { |a| a[:content].blank? }
    has_many :room_bookings, through: :activity_timetable, dependent: :destroy

    has_one :activity_teaching, dependent: :destroy
    accepts_nested_attributes_for :activity_teaching, allow_destroy: true, :reject_if => lambda { |a| a[:content].blank? }
    has_one :activity_tech, dependent: :destroy
    accepts_nested_attributes_for :activity_tech, allow_destroy: true, :reject_if => lambda { |a| a[:content].blank? }
    has_one :activity_assess, dependent: :destroy
    accepts_nested_attributes_for :activity_assess, allow_destroy: true, :reject_if => lambda { |a| a[:content].blank? }
    has_one :activity_gta, dependent: :destroy
    accepts_nested_attributes_for :activity_gta, allow_destroy: true, :reject_if => lambda { |a| a[:content].blank? }

    # Will have 0 to many of these depending on the activity
    has_many :objective_linkers, dependent: :destroy
    has_many :activity_objectives, through: :objective_linkers
    accepts_nested_attributes_for :objective_linkers, allow_destroy: true

    # Each activity is part of at least one degree module
    has_many :activity_programmes, dependent: :destroy
    has_many :programmes, through: :activity_programmes

    # Validates all the mandatory relations exits
    validates :theme, presence: true
    validates :code, presence: true
    validates :uni_module, presence: true

    validates :uni_module, uniqueness: {scope: [:theme, :code]}

    # Activity must have a name
    validates :name, presence: true
    # Checks booleans are either true or false (as presence validator does not work on bools)
    validates :archived, inclusion: {in: [true, false]}
    validates :in_drive, inclusion: {in: [true, false]}

    # Returns the activity's full unique id
    def unique_id
        "#{theme.code}#{code}#{uni_module.code}"
    end
#activity whole things
    # Concatenates activity code
    def activity_code
        return theme.code + code + uni_module.code
    end

    def column_value(col)
        case col
        when "activity_id"
            return unique_id
        when "experiment_name"
            return name
        when "uni_module"
            return uni_module.code
        when "level"
            return uni_module.level
        when "semester"
            return uni_module.semester.value
        when "programmes"
            return degree_string
        when "module_lead"
            return uni_module.user.display_name
        when "mee_lead"
            return user.nil? ? "" : user.display_name
        when "preferred_room"
            return activity_timetable.pref_room.nil? ? "" : activity_timetable.pref_room.display_str
        when "technician"
            return activity_tech.tech_lead.display_name if activity_tech.tech_lead
        when "last_risk_assessment"
            return activity_tech.last_risk_assess
        end
    end

    # Returns a string of all degree codes this activity is a part of
    def degree_string
        degs = ""
        programmes.each do |p|
            degs << "#{p.code}, "
        end
        degs.delete_suffix(', ')
    end

    # Search using all filters, will remove any null
    def self.search(filters)
        id = filters[0]
        theme = filters[1]
        mod = filters[2]
        staff = filters[3]
        mod_level = filters[4]
        semester = filters[5]
        programme = filters[6]
        same_last_year = filters[7]
        checked = filters[8]

        timetable_conditions = {same_as_prev_year: same_last_year[1].downcase, checked_on_timetable: checked[1].downcase}  
        timetable_conditions.delete_if {|k,v| v.blank? }
        mod_conditions = {level: mod_level[1], semester_id: semester[1]}
        mod_conditions.delete_if {|k,v| v.blank? }
        conditions = {id: id[1], theme: theme[1], uni_module_id: mod[1], programmes: programme[1], uni_modules: mod_conditions, activity_timetables: timetable_conditions}
        conditions.delete_if {|k,v| v.blank?}
        
        if !staff[1].blank?
            # Staff member
            module_lead = User.where(id: staff[1])
            modules = UniModule.where(user_id: module_lead)
            activities_module_lead = Activity.where(uni_module_id: modules)

            #Getting activities where the user is the MEE lead
            mee_lead = User.where(id: staff[1])
            activities_mee_lead = Activity.where(user_id: mee_lead)
            
            #Getting activities where the user is the teaching understudy
            activity_teachings = ActivityTeaching.where(user_id: staff[1])
            acitvities_understudy = Activity.where(id: activity_teachings)

            #Getting activities where the user is the technical lead
            activity_tech_leads = ActivityTech.where(tech_lead_id: staff[1])
            activities_tech_lead = Activity.where(id: activity_tech_leads)
            
            #Getting activities where the user is the teaching understudy
            activity_tech_understudy = ActivityTech.where(tech_lead_id: staff[1])
            activities_tech_understudy = Activity.where(id: activity_tech_understudy)

            #Getting activities where the user has been given a GTA invite
            gta_ids = GtaInvite.where(user_id: staff[1]).pluck(:activity_gta_id)
            act_ids = ActivityGta.where(id: gta_ids).pluck(:activity_id)
            acts = Activity.where(id: act_ids)

            #Combining the sets
            activities_non_uniq = activities_module_lead + activities_mee_lead + acitvities_understudy + activities_tech_lead + activities_tech_understudy + acts

            # Return intersection
            return activities_non_uniq & joins(:uni_module, :activity_timetable).where(conditions)
        else
            return joins(:uni_module, :activity_timetable).where(conditions)
        end
    end

end
