class DropdownsController < ApplicationController
  before_action :set_dropdown, only: [:show, :edit, :update, :destroy]

  # GET /dropdowns
  def index
    @dropdowns = Dropdown.order(:id)
    @dropdowns = @dropdowns.group_by(&:display_name)
  end

  # GET /dropdowns/1
  def show
  end

  # GET /dropdowns/new
  def new
    @dropdown = Dropdown.new(drop_down: params[:drop_down], display_name: params[:display_name])
    render layout: false
  end

  # GET /dropdowns/1/edit
  def edit
    render layout: false
  end

  # POST /dropdowns
  def create
    @dropdown = Dropdown.new(dropdown_params)

    if @dropdown.save
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /dropdowns/1
  def update
    if @dropdown.update(dropdown_params)
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /dropdowns/1
  def destroy
    # Checks for dependencies
    dependencies = []
    case @dropdown.drop_down
    when "semester"
      dependencies << Activity.joins(:uni_module).where(uni_modules: {semester_id: @dropdown.id})
    when "assessment"
      dependencies << ActivityAssess.where(pre_assess_type_id: @dropdown.id)
      dependencies << ActivityAssess.where(during_assess_type_id: @dropdown.id)
      dependencies << ActivityAssess.where(post_assess_type_id: @dropdown.id)
    when "post_lab"
      dependencies << ActivityAssess.where(post_lab_type_id: @dropdown.id)
    when "resit"
      dependencies << ActivityTeaching.where(resit_priority_id: @dropdown.id)
    end

    # Takes action - Either delete or notice
    if dependencies.blank?
      @dropdown.destroy
      redirect_to dropdowns_url, notice: 'Dropdown option was successfully removed.'
    else
      redirect_to dropdowns_url, notice: 'Cannot remove dropdown option as there are still dependencies.'
    end
  end

  def audit
    dropdown = Dropdown.find(params[:id])
    @audits = []

    dropdown.audits.each do |d|
      d.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if val.class == Array
          changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
        else
          changes = ["N/A", val.to_s.humanize.capitalize]
        end
        if User.where(id: d.user_id).blank?
          user = "User does not exist"
        else
          user = d.user.display_name
        end
        
        @audits.push([d.created_at.to_date, d.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dropdown
      @dropdown = Dropdown.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dropdown_params
      params.require(:dropdown).permit(:id, :drop_down, :value, :display_name)
    end
end
