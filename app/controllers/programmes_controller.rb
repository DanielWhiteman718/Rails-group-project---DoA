class ProgrammesController < ApplicationController
  before_action :set_programme, only: [:show, :edit, :update, :destroy]

  # GET /programmes
  def index
    @programmes = Programme.order(:code).paginate(page: params[:page])
  end

  # GET /programmes/new
  def new
    @programme = Programme.new
    render layout: false
  end

  # GET /programmes/1/edit
  def edit
    render layout: false
  end

  # POST /programmes
  def create
    @programme = Programme.new(programme_params)

    if @programme.save
      @programmes = Programme.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /programmes/1
  def update
    if @programme.update(programme_params)
      @programmes = Programme.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /programmes/1
  def destroy
    dependent = []
    dependent << ActivityProgramme.where(programme_id: @programme.id)
    dependent << ActivityObjective.where(programme_id: @programme.id)
    dependent = dependent.flatten
    if dependent.blank?
      @programme.destroy
      redirect_to programmes_url, notice: 'Programme successfully removed.'
    else
      redirect_to programmes_url, alert: 'You cannot remove this programme. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    programme = Programme.find(params[:id])
    @audits = []

    programme.audits.each do |p|
      p.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if val.class == Array
          changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
        else
          changes = ["N/A", val.to_s.humanize.capitalize]
        end
        if User.where(id: p.user_id).blank?
          user = "User does not exist"
        else
          user = p.user.display_name
        end
        @audits.push([p.created_at.to_date, p.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programme
      @programme = Programme.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def programme_params
      params.fetch(:programme, {}).permit(:code, :name)
    end
end
