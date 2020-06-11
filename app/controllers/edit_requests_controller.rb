class EditRequestsController < ApplicationController
  
  # GET /edit_requests
  def index
    if params[:status].blank?
      status = [0, 1, 2]
    else
      status = params[:status]
    end
    @count = EditRequest.where(target_id: current_user.id)
    @edit_requests = EditRequest.where(target_id: current_user.id, status: status)
    #EditRequest.where(target_id: current_user.id, status: status)
    # Group by bulk id
    @edit_requests = @edit_requests.group_by(&:bulk_id)
    @edit_requests = @edit_requests.sort_by{|index, request| -index}
    # Only display fully complete requests in this category
    if status == 2
      @edit_requests.delete_if do |index, r|
        if EditRequest.bulk_status(r) == 2 && r.length != EditRequest.where(bulk_id: r[0].bulk_id).length
          true
        end
      end
    end

    @count = @count.group_by(&:bulk_id)
    @count = @count.sort_by{|index, request| -index}
    @new, @outstanding, @completed = 0, 0, 0
    @count.each do |bulk_id, requests|
      case EditRequest.bulk_status(requests)
      when 0
        @new += 1
      when 1
        @outstanding += 1
      when 2
        @completed += 1
      end
    end
    @edit_requests = @edit_requests.paginate(page: params[:page])
  end

  def create
    req_params = params[:edit_request]
    @new_req = EditRequest.new(#req_params)
      id: EditRequest.maximum(:id).next,
      activity_id: req_params[:activity_id],
      initiator_id: req_params[:initiator_id],
      target_id: req_params[:target_id],
      title: req_params[:message],
      message: req_params[:message],
      column_id: req_params[:column_id],
      bulk_id: req_params[:bulk_id],
      status: '0'
    )
    @new_req.save
    respond_to do |format|
      format.html { redirect_to activities_path }
      format.js {}
    end
  end

  def respond
    @bulk_id = params[:bulk_id]
    @request_details = EditRequest.where(bulk_id: @bulk_id).first
    @edit_requests = EditRequest.where(bulk_id: @bulk_id).order(:id)
    @edit_requests.each do |edit_request|
      if edit_request.status == 0
        edit_request.set_status(1)
      end
    end
  end

  def bulk
    @errors = []
    params[:edit_requests].each do |id, val|
      new_val = val[:new_val]
      gta = val[:activity_gta]
      activity = params[:edit_requests][id][:activity]
      timetable = params[:edit_requests][id][:timetable]
      edit_request = EditRequest.find(id)
      @errors << save_change(gta, activity, new_val, edit_request, timetable)
    end

    @errors = @errors.flatten
    @bulk_id = params[:bulk_request][:bulk_id]
    @request_details = EditRequest.where(bulk_id: @bulk_id).first
    @edit_requests = EditRequest.where(bulk_id: @bulk_id).order(:id)
    render :respond
  end

  def single
    id = params[:id]
    new_val = params[:edit_requests][id][:new_val]
    gta = params[:edit_requests][id][:activity_gta]
    activity = params[:edit_requests][id][:activity]
    edit_request = EditRequest.find(id)
    timetable = params[:edit_requests][id][:activity_timetable]
    @errors = []
    @errors << save_change(gta, activity, new_val, edit_request, timetable)
    
    @bulk_id = params[:bulk_request][:bulk_id]
    @request_details = EditRequest.where(bulk_id: @bulk_id).first
    @edit_requests = EditRequest.where(bulk_id: @bulk_id).order(:id)

    render :respond
  end

  def save_change(gta, activity, new_val, edit_request, timetable)
    errors = ""
    # Setup
    if !gta.blank?
      activity_gta = gta[:gta_invites_attributes]
    else
      activity_gta = nil
    end
    if !activity.blank?
      if !activity[:objective_linkers_attributes].nil?
        activity_obj = activity[:objective_linkers_attributes]
      else
        activity_obj = nil
      end
      if !activity[:programme_ids].nil?
        programmes = activity[:programme_ids][1..]
      else
        programmes = nil
      end
    end
    if !timetable.blank?
      if !timetable[:room_ids].nil?
        rooms = timetable[:room_ids][1..]
      else
        rooms = nil
      end
    end
    
    act = edit_request.activity
    # Updating
    if !new_val.blank? 
      errors = edit_request.update(new_val)
    elsif !activity_gta.blank?
      activity_gta.each do |index, gta|
        if gta[:_destroy] == "1"
          act.activity_gta.gta_invites.delete(GtaInvite.find(gta[:id]))
        else
          act.activity_gta.gta_invites.find_or_create_by(user_id: gta[:user_id])
        end
      end
      edit_request.set_status(2)
    elsif !activity_obj.blank?
      activity_obj.each do |index, obj|
        if obj[:_destroy] == "1"
          act.objective_linkers.delete(ObjectiveLinker.find(obj[:id]))
        else
          act.objective_linkers.find_or_create_by(activity_objective_id: obj[:activity_objective_id])
        end
      end
      edit_request.set_status(2)
    elsif !programmes.blank?
      progs = []
      programmes.each do |p|
        progs << Programme.find(p)
      end
      act.update_attribute(:programmes, progs)   
      edit_request.set_status(2)
    elsif !rooms.blank?
      room = []
      rooms.each do |r|
        room << Room.find(r)
      end
      act.activity_timetable.update_attribute(:rooms, room)   
      edit_request.set_status(2)
    elsif new_val.blank?
      errors = ["#{edit_request.column.display_name} cannot be blank. If there are no changes to be made, please click 'No Changes Required'."]
    end
    return errors
  end

  def reject
    edit_request = EditRequest.find(params[:id])
    edit_request.set_status(2)
    edit_request.update_attributes(new_val: "No changes required")
    edit_request.save
    redirect_to respond_edit_requests_path(bulk_id: params[:bulk_request][:bulk_id])
  end
  private
    def set_edit_request
      @edit_request = EditRequest.find(params[:id])
    end

    def edit_request_params
      params.require(:activity_id, :initiator_id, :target_id, :bulk_id, :column, :title, :message, :status)
    end
end
