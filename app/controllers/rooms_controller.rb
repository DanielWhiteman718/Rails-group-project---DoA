class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.order(:code).paginate(page: params[:page])
  end

  # GET /rooms/new
  def new
    @room = Room.new
    render layout: false
  end

  # GET /rooms/1/edit
  def edit
    render layout: false
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      @rooms = Room.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      @rooms = Room.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /rooms/1
  def destroy
    dependent = []
    dependent << ActivityTimetable.where(pref_room_id: @room.id)
    dependent << RoomBooking.where(room_id: @room.id)
    dependent = dependent.flatten
    if dependent.blank?
      @room.destroy
      redirect_to rooms_url, notice: 'Room successfully removed.'
    else
      redirect_to rooms_url, alert: 'You cannot remove this room. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    room = Room.find(params[:id])
    @audits = []

    room.audits.each do |r|
      r.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if val.class == Array
          changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
        else
          changes = ["N/A", val.to_s.humanize.capitalize]
        end
        if User.where(id: r.user_id).blank?
          user = "User does not exist"
        else
          user = r.user.display_name
        end
        @audits.push([r.created_at.to_date, r.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def room_params
      params.fetch(:room, {}).permit(:code, :name)
    end
end
