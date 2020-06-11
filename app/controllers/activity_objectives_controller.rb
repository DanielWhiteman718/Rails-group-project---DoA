class ActivityObjectivesController < ApplicationController
  before_action :set_activity_objective, only: [:show, :edit, :update, :destroy]

  # GET /activity_objectives
  def index
    if params[:search].present?
      @activity_objectives = ActivityObjective.where(programme_id: params[:search][:programme]).paginate(page: params[:page])
      @programme = params[:search][:programme]
    else
      @activity_objectives = ActivityObjective.all.paginate(page: params[:page])
      @programme = nil
    end
    
  end

  # GET /activity_objectives/1
  def show
  end

  # GET /activity_objectives/new
  def new
    @activity_objective = ActivityObjective.new
    render layout: false
  end

  # GET /activity_objectives/1/edit
  def edit
    render layout: false
  end

  # POST /activity_objectives
  def create
    @activity_objective = ActivityObjective.new(activity_objective_params)

    if @activity_objective.save
      @activity_objectives = ActivityObjective.all.paginate(page: params[:page])
      @programme = nil
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /activity_objectives/1
  def update
    if @activity_objective.update(activity_objective_params)
      @activity_objectives = ActivityObjective.all.paginate(page: params[:page])
      @programme = nil
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /activity_objectives/1
  def destroy
    dependent = []
    dependent << ObjectiveLinker.where(activity_objective_id: @activity_objective.id)
    dependent = dependent.flatten
    if dependent.blank?
      @activity_objective.destroy
      redirect_to activity_objectives_url, notice: 'Learning outcome successfully removed.'
    else
      redirect_to activity_objectives_url, alert: 'You cannot remove this learning outcome. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    obj = ActivityObjective.find(params[:id])
    @audits = []

    obj.own_and_associated_audits.each do |o|
      o.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if val.class == Array
          if field == "objective_id"
            changes = [Objective.find(val[0]).display_str, Objective.find(val[1]).display_str]
          elsif field == "programme_id"
            changes = [Programme.find(val[0]).code, Programme.find(val[1]).code]
          else
            changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
          end
        else
          if field == "objective_id"
            changes = ["N/A", Objective.find(val).display_str]
          elsif field == "programme_id"
            changes = ["N/A", Programme.find(val).code]
          else
            changes = ["N/A", val.to_s.humanize.capitalize]
          end
        end
        if User.where(id: o.user_id).blank?
          user = "User does not exist"
        else
          user = o.user.display_name
        end
        @audits.push([o.created_at.to_date, o.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_objective
      @activity_objective = ActivityObjective.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_objective_params
      params.fetch(:activity_objective, {}).permit(:objective_id, :short_desc, :long_desc,
        :programme_id)
    end
end
