class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :crerequest]
  skip_before_action :verify_authenticity_token
  
  # GET /activities
  def index
    if params[:search].present?
      # Filters
      search = params[:search][:fils]
      @filters = [
        ["id", search[:id]], ["theme", search[:theme]], ["uni_module", search[:uni_module]],
        ["staff_member", search[:staff_member]], ["level", search[:level]], ["semester", search[:semester]],
        ["programme", search[:programme]], ["same_last_year", search[:same_last_year]], ["checked", search[:checked]]
      ]
      @current_filters = filter_string(@filters)

      # Activities that match the filters
      @activities = Activity.search(@filters).sort_by{|a| a.activity_code}
      @activities_by_name = @activities.sort_by{|a| a.name}
      @activities_id = @activities.pluck(:id)
      @activities = @activities.paginate(page: params[:page])
      # Columns to show
      @columns = params[:search][:cols]
      @post_req = true
    else
      # All activities
      @activities = Activity.all.sort_by{|a| a.activity_code}
      @activities_by_name = @activities.sort_by{|a| a.name}
      @activities_id = @activities.pluck(:id)
      @activities = @activities.paginate(page: params[:page])

      # Reset columns
      @columns = user_columns

      # Reset filters
      @filters = [
        ["id", nil], ["theme", nil], ["uni_module", nil], ["staff_member", nil], ["level", nil], ["semester", nil],
        ["programme", nil], ["same_last_year", nil], ["checked", nil]
      ]
      @current_filters = filter_string(@filters)
      # GET request was used here, so false. Needed CSV button
      @post_req = false
    end
    
  end

  # Generate columns based on user group
  def user_columns
    case current_user.role
    # Admin
    when 0
      return [["activity_id", "true"],["experiment_name", "true"],["mee_lead", "true"],["preferred_room", "true"],["semester", "true"]]
    # Academic
    when 2
      return [["activity_id", "true"],["experiment_name", "true"],["level", "true"],["mee_lead", "true"],["uni_module", "true"],["module_lead", "true"],["preferred_room", "true"],["programmes", "true"],["semester", "true"]]
    # Technician
    when 1
      return [["activity_id", "true"],["experiment_name", "true"],["last_risk_assessment", "true"],["mee_lead", "true"],["preferred_room", "true"],["semester", "true"],["technician", "true"]]
    end
  end

  def user_edit
    case current_user.role
    # Admin
    when 0
      return {theme: false, code: false, name: false, mee_lead: false, programmes: false, notes: false, uni_module: false,
        academic_understudy: false, mole: false, g_drive: false, resit: false, num_assess: false, pre_assess: false, 
        during_assess: false, post_assess: false, post_lab: false, assess_weight: false, assess_notes: false,
        ratio: false, marking_time: false, job_desc: false, jobshop_desc: false, criteria: false, gta_invite: false,
        level_desc: false, tech_lead: false, tech_ustudy: false, last_risk: false, next_risk: false, equipment: false,
        cost_per_student: false, same_as_prev: false, checked_time: false, min_week: false, max_week: false,
        capacity: false, pref_room: false, other_rooms: false, duration: false, setup: false, series_setup: false, 
        takedown: false, kit_prep: false, time_notes: false}
    # Technician
    when 1
      return {theme: true, code: true, name: true, mee_lead: true, programmes: true, notes: false, uni_module: true,
        academic_understudy: true, mole: true, g_drive: true, resit: true, num_assess: true, pre_assess: true, 
        during_assess: true, post_assess: true, post_lab: true, assess_weight: true, assess_notes: true,
        ratio: true, marking_time: true, job_desc: true, jobshop_desc: true, criteria: true, gta_invite: false,
        level_desc: true, tech_lead: true, tech_ustudy: false, last_risk: false, next_risk: false, equipment: false,
        cost_per_student: false, same_as_prev: true, checked_time: true, min_week: true, max_week: true,
        capacity: true, pref_room: false, other_rooms: false, duration: true, setup: false, series_setup: false, 
        takedown: false, kit_prep: false, time_notes: false}
    # Academic
    when 2
      return {theme: true, code: true, name: true, mee_lead: true, programmes: true, notes: false, uni_module: true,
        academic_understudy: false, mole: false, g_drive: false, resit: false, num_assess: false, pre_assess: false, 
        during_assess: false, post_assess: false, post_lab: false, assess_weight: false, assess_notes: false,
        ratio: false, marking_time: false, job_desc: false, jobshop_desc: false, criteria: false, gta_invite: false,
        level_desc: false, tech_lead: true, tech_ustudy: true, last_risk: true, next_risk: true, equipment: true,
        cost_per_student: true, same_as_prev: false, checked_time: true, min_week: true, max_week: true,
        capacity: true, pref_room: false, other_rooms: false, duration: true, setup: true, series_setup: true, 
        takedown: true, kit_prep: true, time_notes: false}
    end
  end

  # GET /activities/output
  def all_output
    # Creates a CSV file all activities in the database
    @activities = Activity.all
    respond_to do |format|
      format.csv {send_data @activities.to_csv, filename: "activities-#{Date.today}.csv",
        disposition: 'attachment', type: 'text/csv'}
    end
  end

  # POST /activities/output
  def some_output
    # Creates a CSV file of activities that were filtered using update_DoA_table
    id_list = params["output"]["act_ids"].split(" ")
    @activities = Activity.where(id: id_list)
    # If filters returned no results, file will be empty, do not create
    if @activities.empty?
      redirect_to activities_path, notice: 'No activities selected, no CSV file was created'
    else
      respond_to do |format|
        format.csv {send_data @activities.to_csv, filename: "activities-#{Date.today}.csv",
          disposition: 'attachment', type: 'text/csv'}
      end
    end
  end

  # GET /activities/lab_book
  def lab_book_all
    # Creates a CSV file of all activities, but only the attributes needed lab books
    @activities = Activity.all
    respond_to do |format|
      format.csv {send_data @activities.lab_book_csv, filename: "lab_books-#{Date.today}.csv",
        disposition: 'attachment', type: 'text/csv'}
    end
  end

  # POST /activities/lab_book
  def lab_book_some
    # Creates a CSV file of activities that were filtered using update_DoA_table
    # but only includes attributes needed lab books
    id_list = params["lab_book"]["act_ids"].split(" ")
    @activities = Activity.where(id: id_list)
    if @activities.empty?
      redirect_to activities_path, notice: 'No activities selected, no CSV file was created'
    else
      respond_to do |format|
        format.csv {send_data @activities.lab_book_csv, filename: "lab_books-#{Date.today}.csv",
          disposition: 'attachment', type: 'text/csv'}
      end
    end
  end

  # GET /activities/new
  def new
    @form_type = "creating"
    @edit = {}
    @activity = Activity.new
    @uni_module = UniModule.new
    @activity.build_activity_assess
    @activity.build_activity_tech
    @activity.build_activity_teaching
    @activity.build_activity_gta
    @activity.build_activity_timetable
    @objective_collection = ActivityObjective.all
    render layout: false
  end

  # GET /activities/1/edit
  def edit
    @form_type = "updating"
    @edit = user_edit
    @uni_module = @activity.uni_module
    @objective_collection = ActivityObjective.all
    render layout: false
  end

  # GET /activities/1/edit
  def show
    @form_type = "displaying"
    @edit = user_edit
    @uni_module = @activity.uni_module
    @objective_collection = ActivityObjective.all
    render layout: false
  end

  # GET /activities/1/crerequest
  def crerequest
    @edit_request = EditRequest.new
    render layout: false
  end

  def send_bulk
    # Pass activities
    id_list = params["send_bulk"]["act_ids"].split(" ")
    @activities = Activity.where(id: id_list).count
    @act_ids = params["send_bulk"]["act_ids"]
    # Filter out certain columns, labels (28 and 30 for gta and objective?)
    @columns = Column.columns_for_request(Column.all)
  end
  
  def bulk_request
    # Process bulk requests
    act_ids = params[:bulk_request][:act_ids].split(" ")
    users = params[:bulk_request][:users][1..]
    columns = params[:bulk_request][:columns][1..]
    message = params[:bulk_request][:message]
    initiator = current_user.id
    if users.blank? || columns.blank? || message.blank?
      redirect_to send_bulk_activities_path(send_bulk: {act_ids: act_ids}), alert: "Please fill in the message, users and fields."
    else
      act_ids.each do |a|
        act = Activity.find(a)
        # Find associated users
        users.each do |u|
          bulk_id = EditRequest.maximum(:bulk_id) + 1
          if u == "MEE Lead"
            target = act.user_id
          elsif u == "Module Lead"
            target = act.uni_module.user_id
          elsif u == "Technical Lead"
            target = act.activity_tech.tech_lead_id
          else
            next
          end
          # Save edit request for each column
          columns.each do |c|
            edit = EditRequest.new(activity_id: a, initiator_id: initiator, target_id: target, title: message, message: message,
              column_id: c, bulk_id: bulk_id, status: 0)
            edit.save!
            
          end
        end 
      end
      redirect_to activities_path, notice: "Edit request sent successfully."
    end
    
  end

  # POST /activities
  def create
    # Build's activity and associated models but does not save to the database
    @activity = Activity.new(activity_params)
    @activity.build_activity_assess(activity_params[:activity_assess_attributes])
    @activity.build_activity_tech(activity_params[:activity_tech_attributes])
    @activity.build_activity_teaching(activity_params[:activity_teaching_attributes])
    @activity.build_activity_gta(activity_params[:activity_gta_attributes])
    @activity.build_activity_timetable(activity_params[:activity_timetable_attributes])
    if !activity_params[:activity_objectives_attributes].nil?
      activity_params[:activity_objectives_attributes].each do |id, objective|
        @activity.activity_objectives.build(objective_id: objective[:objective_id], short_desc: objective[:short_desc],
          long_desc: objective[:long_desc])
      end
    end
    if !activity_params[:activity_gta_attributes][:gta_invites_attributes].nil?
      activity_params[:activity_gta_attributes][:gta_invites_attributes].each do |id, invite|
        @activity.activity_gta.gta_invites.build(user_id: invite[:user_id])
      end
    end

    if @activity.save
      @activities = Activity.all.sort_by{|a| a.activity_code}
      @activities_by_name = @activities.sort_by{|a| a.name}
      @activities_id = @activities.pluck(:id)
      @activities = @activities.paginate(page: params[:page])
      @columns = user_columns
      @filters = [["id", nil], ["theme", nil], ["uni_module", nil], ["staff_member", nil], ["level", nil], ["semester", nil],
        ["programme", nil], ["same_last_year", nil], ["checked", nil]]
      @current_filters = filter_string(@filters)
      render 'update_success'
    else
      @errors = []
      # Format error messages display
      @activity.errors.each do |att, msg|
        att_name = att.to_s.split(".")
        if att_name.size == 1
          tab = "Lab Information:"
          @errors << tab + " " + att_name[0].to_s.capitalize.humanize + " " + msg
        else
          case att_name[0]
          when "activity_assess"
            tab = "Assessment:"
          when "activity_teaching"
            tab = "Teaching:"
          when "activity_gta"
            tab = "GTA Information:"
          when "activity_objectives"
            tab = "Learning Outcomes:"
          when "activity_tech"
            tab = "Technical"
          when "activity_timetable"
            tab = "Timetabling"
          end
          @errors << tab + " " + att_name[1].to_s.capitalize.humanize + " " + msg
        end
        
      end
      
      @form_type = "creating"
      @edit = {}
      @uni_module = UniModule.find(activity_params[:uni_module_id])
      render 'create_failure'
    end
  end

  # PATCH/PUT /activities/1
  def update
    @activity.attributes = activity_params
    @activity.activity_assess.attributes = activity_params[:activity_assess_attributes]
    @activity.activity_tech.attributes = activity_params[:activity_tech_attributes]
    @activity.activity_teaching.attributes = activity_params[:activity_teaching_attributes]
    @activity.activity_gta.attributes = activity_params[:activity_gta_attributes]
    @activity.activity_timetable.attributes = activity_params[:activity_timetable_attributes]
    
    if !activity_params[:activity_objectives_attributes].nil?
      activity_params[:activity_objectives_attributes].each do |index, objective|
        if objective[:_destroy] == "1"
          @activity.objective_linkers.delete(ObjectiveLinker.find(objective[:id]))
        else
          @activity.objective_linkers.find_or_create_by(activity_objective_id: objective[:activity_objective_id])
        end
      end
    end
    
    if !activity_params[:activity_gta_attributes][:gta_invites_attributes].nil?
      activity_params[:activity_gta_attributes][:gta_invites_attributes].each do |index, gta|
        if gta[:_destroy] == "1"
          @activity.activity_gta.gta_invites.delete(GtaInvite.find(gta[:id]))
        else
          @activity.activity_gta.gta_invites.find_or_create_by(user_id: gta[:user_id])
        end
      end
    end

    if @activity.save
      @activities = Activity.all.sort_by{|a| a.activity_code}
      @activities_by_name = @activities.sort_by{|a| a.name}
      @activities_id = @activities.pluck(:id)
      @activities = @activities.paginate(page: params[:page])
      @columns = user_columns
      @filters = [["id", nil], ["theme", nil], ["uni_module", nil], ["staff_member", nil], ["level", nil], ["semester", nil],
        ["programme", nil], ["same_last_year", nil], ["checked", nil]]
      @current_filters = filter_string(@filters)
      render 'update_success'
    else
      @errors = []
      # Format error messages display
      @activity.errors.each do |att, msg|
        att_name = att.to_s.split(".")
        if att_name.size == 1
          tab = "Lab Information:"
          @errors << tab + " " + att_name[0].to_s.capitalize.humanize + " " + msg
        else
          case att_name[0]
          when "activity_assess"
            tab = "Assessment:"
          when "activity_teaching"
            tab = "Teaching:"
          when "activity_gta"
            tab = "GTA Information:"
          when "activity_objectives"
            tab = "Learning Outcomes:"
          when "activity_tech"
            tab = "Technical:"
          when "activity_timetable"
            tab = "Timetabling:"
          end
          @errors << tab + " " + att_name[1].to_s.capitalize.humanize + " " + msg
        end
        
      end
      
      @form_type = "creating"
      @edit = user_edit
      @uni_module = UniModule.find(activity_params[:uni_module_id])
      render 'update_failure'
    end
  end

  # DELETE /activities/1
  def destroy
    @activity.destroy
    redirect_to activities_url, notice: 'Activity was successfully removed.'
  end
 
  def my_activities
    #Getting activities where the user is the uni_module lead
    module_lead = User.where(id: current_user)
    modules = UniModule.where(user_id: module_lead)
    activities_module_lead = Activity.where(uni_module_id: modules)

    #Getting activities where the user is the MEE lead
    mee_lead = User.where(id: current_user)
    activities_mee_lead = Activity.where(user_id: mee_lead)
    
    #Getting activities where the user is the teaching understudy
    activity_teachings = ActivityTeaching.where(user_id: current_user)
    acitvities_understudy = Activity.where(id: activity_teachings)

    #Getting activities where the user is the technical lead
    activity_tech_leads = ActivityTech.where(tech_lead_id: current_user)
    activities_tech_lead = Activity.where(id: activity_tech_leads)
    
    #Getting activities where the user is the teaching understudy
    activity_tech_understudy = ActivityTech.where(tech_lead_id: current_user)
    activities_tech_understudy = Activity.where(id: activity_tech_understudy)

    #Getting activities where the user has been given a GTA invite
    gta_ids = GtaInvite.where(user_id: current_user.id).pluck(:activity_gta_id)
    act_ids = ActivityGta.where(id: gta_ids).pluck(:activity_id)
    acts = Activity.where(id: act_ids)

    #Combining the sets
    activities_non_uniq = activities_module_lead + activities_mee_lead + acitvities_understudy + activities_tech_lead + activities_tech_understudy + acts
    
    #Setting the global variables
    @activities = activities_non_uniq.uniq.sort_by{|a| a.activity_code}
    @activities_by_name = @activities.sort_by{|a| a.name}
    @activities_id = @activities.pluck(:id)
    @activities = @activities.paginate(page: params[:page])
    @columns = user_columns
    @filters = [["id", nil], ["theme", nil], ["uni_module", nil], ["staff_member", current_user.id], ["level", nil], ["semester", nil],
      ["programme", nil], ["same_last_year", nil], ["checked", nil]]
    @current_filters = filter_string(@filters)
    render 'index'
  end

  def reset
    @all_activities = Activity.all.sort_by{|a| a.name}
    @activities = Activity.all.sort_by{|a| a.activity_code}
    @activities_by_name = @activities.sort_by{|a| a.name}
    @activities_id = @activities.pluck(:id)
    @activities = @activities.paginate(page: params[:page])
    @columns = user_columns
    @filters = [["id", nil], ["theme", nil], ["uni_module", nil], ["staff_member", nil], ["level", nil], ["semester", nil], ["programme", nil], ["same_last_year", nil], ["checked", nil]]
    @current_filters = filter_string(@filters)
    # GET request was used here, so false. Needed CSV button
    @post_req = false

    # Called search but only updates the table based on @activities and @columns
    render 'index'
  end

  def filter
    @columns = params[:search][:cols]
    search = params[:search][:fils]
    @filters = [["id", search[:id]], ["theme", search[:theme]], ["uni_module", search[:uni_module]], ["staff_member", search[:staff_member]], ["level", search[:level]], ["semester", search[:semester]], ["programme", search[:programme]], ["same_last_year", search[:same_last_year]], ["checked", search[:checked]]]  
    respond_to do |format|
      format.js
      format.html
    end
  end

  def change_module
    @uni_module = UniModule.find(params[:module_id])
    respond_to do |format|
      format.js
    end
  end 

  
  def audit
    # Retrieve all associated audits
    activity = Activity.find(params[:id])
    audits = []
    audits << activity.audits
    audits << activity.activity_assess.audits
    audits << activity.activity_gta.own_and_associated_audits #GTA invites
    audits << activity.activity_timetable.own_and_associated_audits #Room bookings
    audits << activity.activity_teaching.audits
    audits << activity.activity_tech.audits
    activity.objective_linkers.each do |a|
      audits << a.audits
    end
    activity.activity_programmes.each do |a|
      audits << a.audits
    end
    activity.activity_gta.gta_invites.each do |a|
      audits << a.audits
    end
    activity.activity_timetable.room_bookings.each do |a|
      audits << a.audits
    end

    # Add deleted gta invites and objectives
    audits << Audited::Audit.where("action = 'destroy' AND ((audited_changes->'activity_id') = ? OR (audited_changes->'activity_gta_id') = ?)", "#{activity.id}", "#{activity.id}")

    # Newest changes first
    audits = audits.flatten.sort_by(&:id).reverse

    @audits = []

    audits.each do |a|
      
      a.audited_changes.each do |field, val|
        # Ignore these fields
        if !(field == "name_abrv" || field == "activity_id" || field == "activity_gta_id" || field == "activity_timetable_id")
          f = field.to_s.humanize.capitalize
          # Format data
          if a.action == "destroy"
            vals = [val, "N/A"]
          elsif val.kind_of?(Array)
            vals = [val[0], val[1]]
          else
            vals = ["N/A", val]
          end

          # Find values based on field
          # Check exists and return appropriate
          case field
          when "activity_objective_id"
            if vals[0] != "N/A" && ActivityObjective.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = ActivityObjective.find(vals[0]).display_str
            end
            if vals[1] != "N/A" && ActivityObjective.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = ActivityObjective.find(vals[1]).display_str
            end

          when "user_id", "tech_lead_id", "tech_ustudy_id"
            # Set right label
            if a.auditable_type == "GtaInvite"
              f = "GTA Invite"
            elsif a.auditable_type == "Activity"
              f = "MEE Lead"
            elsif a.auditable_type == "ActivityTeaching"
              f = "Academic understudy"
            elsif field == "tech_lead_id"
              f = "Technical lead"
            elsif field == "tech_ustudy_id"
              f = "Technical understudy"
            end
            # Set value
            if vals[0] != "N/A" && User.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = User.find(vals[0]).display_name
            end
            if vals[1] != "N/A" && User.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = User.find(vals[1]).display_name
            end

          when "programme_id"
            if vals[0] != "N/A" && Programme.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = Programme.find(vals[0]).code
            end
            if vals[1] != "N/A" && Programme.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = Programme.find(vals[1]).code
            end

          when "pre_assess_type_id", "during_assess_type_id", "post_assess_type_id", "post_lab_type_id", "resit_priority_id"
            if vals[0] != "N/A" && Dropdown.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = Dropdown.find(vals[0]).value
            end
            if vals[1] != "N/A" && Dropdown.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = Dropdown.find(vals[1]).value
            end

          when "room_id", "pref_room_id"
            # Set right label
            if a.auditable_type == "RoomBooking"
              f = "Other rooms"
            end
            # Set value
            if vals[0] != "N/A" && !vals[0].nil? &&  Room.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A" && !vals[0].nil?
              vals[0] = Room.find(vals[0]).display_str
            end
            if vals[1] != "N/A" && !vals[1].nil? && Room.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A" && !vals[1].nil?
              vals[1] = Room.find(vals[1]).display_str
            end

          when "theme_id"
            if vals[0] != "N/A" && Theme.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = Theme.find(vals[0]).code
            end
            if vals[1] != "N/A" && Theme.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = Theme.find(vals[1]).code
            end

          when "uni_module_id"
            if vals[0] != "N/A" && UniModule.find(vals[0]).blank?
              vals[0] = "#{f} does not exist"
            elsif vals[0] != "N/A"
              vals[0] = UniModule.find(vals[0]).code
            end
            if vals[1] != "N/A" && UniModule.find(vals[1]).blank?
              vals[1] = "#{f} does not exist"
            elsif vals[1] != "N/A"
              vals[1] = UniModule.find(vals[1]).code
            end

          when "notes"
            case a.auditable_type
            when "Activity"
              f = "General notes"
            when "ActivityAssess"
              f = "Assessment notes"
            when "ActivityTimetable"
              f = "Timetabling notes"
            end
          end

          if User.where(id: a.user_id).blank?
            user = "User does not exist"
          else
            user = a.user.display_name
          end

          # Add to audits list
          if a.action == "destroy"
            @audits << [a.created_at.to_date, "Remove", f, vals[0], vals[1], user]
          else
            @audits << [a.created_at.to_date, a.action.capitalize, f, vals[0], vals[1], user]
          end
        end
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  
  def filter_string(filters)
    fils = ""
    filters.each do |f|
      if !f[1].blank?
        case f[0]
        when "id"
          val = Activity.find(f[1]).name
          label = "name"
        when "theme"
          label = f[0]
          val = Theme.find(f[1]).code
        when "uni_module"
          label = f[0]
          val = UniModule.find(f[1]).code
        when "staff_member"
          val = User.find(f[1]).display_name
        when "level"
          label = f[0]
          val = f[1]
        when "semester"
          label = f[0]
          val = Dropdown.find(f[1]).value
        when "programme"
          label = f[0]
          val = Programme.find(f[1]).code
        when "same_last_year"
          label = "same as last year"
          if f[1] == "1"
            val = "True"
          elsif f[1] == "0"
            val = "False"
          end
        when "checked"
          label = "checked on timetable"
          if f[1] == "1"
            val = "True"
          elsif f[1] == "0"
            val = "False"
          end
        end
        if fils.blank?
          fils += " #{label} - #{val}"
        else
          fils += ", #{label} - #{val}"
        end
      end
    end
    return fils
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_params
      params.require(:activity).permit(:theme_id, :code, :uni_module_id, :name,
        :name_abrv, :user_id, :archived, :in_drive, :notes, programme_ids:[],
        activity_assess_attributes: [:id, :num_assess, :pre_assess_type_id, :during_assess_type_id,
        :post_assess_type_id, :post_lab_type_id, :assess_weight, :notes],
        activity_tech_attributes: [:id, :tech_lead_id, :tech_ustudy_id, :last_risk_assess, :next_risk_assess,
        :equip_needed, :cost_per_student],
        activity_teaching_attributes: [:id, :user_id, :mole_pub_link, :g_drive_link, :resit_priority_id],
        activity_gta_attributes: [:id, :staff_ratio, :marking_time, :job_desc, :jobshop_desc, :criteria,
        gta_invites_attributes:[:id, :user_id, :_destroy]],
        activity_timetable_attributes: [:id, :same_as_prev_year, :checked_on_timetable, :capacity, :min_week_num, :max_week_num,
        :duration, :setup_time, :series_setup_time, :takedown_time, :kit_prep_time, :notes, :pref_room_id, room_ids:[]],
        objective_linkers_attributes:[:id, :activity_objective_id, :obj_programme, :_destroy])
    end

end