class ObjectivesController < ApplicationController
  before_action :set_objective, only: [:show, :edit, :update, :destroy]

  # GET /objectives
  def index
    @objectives = Objective.order(:code)
  end

  # GET /objectives/new
  def new
    @objective = Objective.new
    render layout: false
  end

  # GET /objectives/1/edit
  def edit
    render layout: false
  end

  # POST /objectives
  def create
    @objective = Objective.new(objective_params)

    if @objective.save
      @objectives = Objective.order(:code)
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /objectives/1
  def update
    if @objective.update(objective_params)
      @objectives = Objective.order(:code)
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /objectives/1
  def destroy
    dependent = []
    dependent << ActivityObjective.where(objective_id: @objective.id)
    dependent = dependent.flatten
    if dependent.blank?
      @objective.destroy
      redirect_to objectives_url, notice: 'Learning outcome code successfully removed.'
    else
      redirect_to objectives_url, alert: 'You cannot remove this learning outcome code. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    obj = Objective.find(params[:id])
    @audits = []

    obj.audits.each do |o|
      o.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if val.class == Array
          changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
        else
          changes = ["N/A", val.to_s.humanize.capitalize]
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
    def set_objective
      @objective = Objective.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def objective_params
      params.fetch(:objective, {}).permit(:code, :name)
    end
end
