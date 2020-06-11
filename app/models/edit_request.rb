# == Schema Information
#
# Table name: edit_requests
#
#  id           :bigint           not null, primary key
#  message      :text
#  new_val      :string
#  status       :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :bigint
#  bulk_id      :integer
#  column_id    :bigint
#  initiator_id :bigint
#  target_id    :bigint
#
# Indexes
#
#  index_edit_requests_on_activity_id   (activity_id)
#  index_edit_requests_on_column_id     (column_id)
#  index_edit_requests_on_initiator_id  (initiator_id)
#  index_edit_requests_on_target_id     (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (column_id => columns.id)
#

class EditRequest < ApplicationRecord
  
  # Request to change something about an activity

  # Column_id is the id of the entry in the columns table which identifies
  # the column that needs changing

  # Enums for request status
  @@NEW = 0
  @@OUTSTANDING = 1
  @@COMPLETED = 2

  def new_req
      return @@NEW
  end

  def outstanding_req
      return @@OUTSTANDING
  end

  def completed_req
      return @@COMPLETED
  end

  # Convert status from enums to string
  def convert_status
      case status
      when 0
        return "New"
      when 1
        return "Outstanding"
      when 2
        return "Completed"
      end
  end

  def self.bulk_status(requests)
    # Looks at the minimum status for each request in the bulk request
    return (requests.map {|r| r[:status]}).min
  end

  def self.outstanding_requests(requests)
    count = 0
    requests.each do |r|
      if r.status == 0 || r.status == 1
        count += 1
      end
    end
    return count
  end

  def set_status(new_s)
    self.status = new_s
    self.save
  end

  def update(new_val)
    table = column.table
    field = column.db_name
    case table
    when "activities"
      a = activity
    when "activity_assesses"
      a = activity.activity_assess
    when "activity_gta"
      a = activity.activity_gta
    when "activity_teachings"
      a = activity.activity_teaching
    when "activity_teches"
      a = activity.activity_tech
    when "activity_timetables"
      a = activity.activity_timetable
    end

    # Save to activity
    a[field.to_sym] = new_val
    if a.save
      self.set_status(2)
      # Set new_val for request
      self.new_val = new_val
      self.save
    else 
      return a.errors.full_messages
    end
  end

  # Hash to convert status enum to a readable string
  @@STATUS_STRINGS = {
    @@NEW => "New",
    @@OUTSTANDING => "Outstanding",
    @@COMPLETED => "Completed",
  }

  def self.status_strings
      @@STATUS_STRINGS
  end

  # Must reference the activity that needs changing
  belongs_to :activity
  # References two users
  # Initiator is the person who sends the request
  belongs_to :initiator, :class_name => 'User', foreign_key: 'initiator_id'
  # Target is the person who receives the request
  belongs_to :target, :class_name => 'User', foreign_key: 'target_id'
  # Column for request
  belongs_to :column

  # Validates foreign keys + title exist
  validates :activity_id, presence: true
  validates :message, presence: true
  validates :bulk_id, presence: true
  validates :column_id, presence: true
  validates :initiator_id, presence: true
  validates :target_id, presence: true
  validates :title, presence: true
  # Checks status exists and is within bounds
  validates :status, presence: true
  validates_inclusion_of :status, in: @@NEW..@@COMPLETED

  # Return current value of the specified field
  def field_current_val
    field = column.db_name
    table = column.table
    activity_tech = activity.activity_tech
    if field == "user_id" && table == "gta_invites" 
      gta_invites = ""
      activity.activity_gta.gta_invites.each do |gta|
        if gta_invites != ""
          gta_invites = gta_invites + ", "
        end
        gta_invites = gta_invites + gta.user.display_name
      end
      return gta_invites, nil
    elsif field == "objective_id" && table == "activity_objective"  
      objectives = ""
      activity.objective_linkers.each do |obj|
        if objectives != ""
          objectives = objectives + ", "
        end
        objectives = objectives + obj.activity_objective.display
      end
      return objectives, nil
    elsif field == "room_id"
      return activity.activity_timetable.other_room_str, nil
    elsif field == "id" && table == "programmes"
      return activity.degree_string, nil
    end

    # Case statements for special cases where db_name does not match activity whole names
    case field
    when "theme_id"
        return activity.theme.code, Theme.all.pluck(:id, :code)
    when "uni_module_id"
        return activity.uni_module.code, UniModule.all.pluck(:id, :code)
    when "user_id"
      if table == "activities"
        return activity.user.display_name, User.all.pluck(:id, :display_name)
      else
        return activity.activity_teaching.user.display_name, User.all.pluck(:id, :display_name)
      end
    when "pref_room_id"
      if activity.activity_timetable.pref_room_id == nil
        return nil, Room.order(:code)
      else
        return activity.activity_timetable.pref_room.display_str, Room.order(:code)
      end
    when "tech_lead_id"
        return activity_tech.tech_lead.display_name, User.all.pluck(:id, :display_name)
    when "tech_ustudy_id"
        return activity_tech.tech_ustudy.display_name, User.all.pluck(:id, :display_name)

    # Case statements for special cases where the result is an enum
    when "pre_assess_type_id"
        return activity.activity_assess.pre_assess_type.value, Dropdown.where(drop_down: "assessment").pluck(:id, :value)
    when "during_assess_type_id"
      return activity.activity_assess.during_assess_type.value, Dropdown.where(drop_down: "assessment").pluck(:id, :value)
    when "post_assess_type_id"
      return activity.activity_assess.post_assess_type.value, Dropdown.where(drop_down: "assessment").pluck(:id, :value)
    when "post_lab_type_id"
        return activity.activity_assess.post_lab_type.value, Dropdown.where(drop_down: "post_lab").pluck(:id, :value)
    when "resit_priority_id"
        return activity.activity_teaching.resit_priority.value, Dropdown.where(drop_down: "resit").pluck(:id, :value)
    else

      # Other cases
      case table
      when "activities"
        a = activity
      when "activity_assesses"
        a = activity.activity_assess
      when "activity_gta"
        a = activity.activity_gta
      when "activity_teachings"
        a = activity.activity_teaching
      when "activity_teches"
        a = activity.activity_tech
      when "activity_timetables"
        a = activity.activity_timetable
      end
  
      return a[field.to_sym], nil
    end

  end

  # Return current value of the specified field
  def field_new_val
    if new_val != "No changes required"
      field = column.db_name
      table = column.table
      activity_tech = activity.activity_tech
      if field == "user_id" && table == "gta_invites" 
        gta_invites = ""
        activity.activity_gta.gta_invites.each do |gta|
          if gta_invites != ""
            gta_invites = gta_invites + ", "
          end
          gta_invites = gta_invites + gta.user.display_name
        end
        return gta_invites
      elsif field == "objective_id" && table == "activity_objective"  
        objectives = ""
        activity.objective_linkers.each do |obj|
          if objectives != ""
            objectives = objectives + ", "
          end
          objectives = objectives + obj.activity_objective.display
        end
        return objectives
      elsif field == "id" && table == "programmes"
        return activity.degree_string
      elsif field == "room_id"
        return activity.activity_timetable.other_room_str
      end

      # Case statements for special cases where db_name does not match activity whole names
      case field
      when "theme_id"
        return Theme.find(new_val).code
      when "uni_module_id"
        return UniModule.find(new_val).code
      when "pref_room_id"
        return Room.find(new_val).display_str
      when "user_id", "tech_lead_id", "tech_ustudy_id"
        return User.find(new_val).display_name
      # Case statements for special cases where the result is an enum
      when "pre_assess_type_id", "during_assess_type_id", "post_assess_type_id", "post_lab_type_id", "resit_priority_id"
        return Dropdown.find(new_val).value
      else
        return new_val
      end 
    else
      return new_val
    end
  end
end
