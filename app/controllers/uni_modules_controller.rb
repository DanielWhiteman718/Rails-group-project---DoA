class UniModulesController < ApplicationController
  before_action :set_uni_module, only: [:show, :edit, :update, :destroy]

  # GET /uni_modules
  def index
    @uni_modules = UniModule.order(:code).paginate(page: params[:page])
  end

  # GET /uni_modules/1
  def show
  end

  # GET /uni_modules/new
  def new
    @uni_module = UniModule.new
    render layout: false
  end

  # GET /uni_modules/1/edit
  def edit
    render layout: false
  end

  # POST /uni_modules
  def create
    @uni_module = UniModule.new(uni_module_params)

    if @uni_module.save
      @uni_modules = UniModule.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /uni_modules/1
  def update
    if @uni_module.update(uni_module_params)
      @uni_modules = UniModule.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /uni_modules/1
  def destroy
    dependent = []
    dependent << Activity.where(uni_module_id: @uni_module.id)
    dependent = dependent.flatten
    if dependent.blank?
      @uni_module.destroy
      redirect_to uni_modules_url, notice: 'Module successfully removed.'
    else
      redirect_to uni_modules_url, alert: 'You cannot remove this module. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    uni_module = UniModule.find(params[:id])
    @audits = []

    uni_module.audits.each do |mod|
      mod.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if field == "user_id"
          f = "Module lead"
          if val.class == Array
            changes = [User.find(val[0]).display_name, User.find(val[1]).display_name]
          else
            changes = ["N/A", User.find(val).display_name]
          end
        elsif field == "semester_id"
          if val.class == Array
            changes = [Dropdown.find(val[0]).value, Dropdown.find(val[1]).value]
          else
            changes = ["N/A", Dropdown.find(val).value]
          end
        else   
          if val.class == Array
            changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
          else
            changes = ["N/A", val.to_s.humanize.capitalize]
          end
        end
        if User.where(id: mod.user_id).blank?
          user = "User does not exist"
        else
          user = mod.user.display_name
        end
        @audits.push([mod.created_at.to_date, mod.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uni_module
      @uni_module = UniModule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def uni_module_params
      params.fetch(:uni_module, {}).permit(:code, :name, :user_id, :credits, :level, :semester_id)
    end
end
