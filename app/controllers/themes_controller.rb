class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  # GET /themes
  def index
    @themes = Theme.order(:code).paginate(page: params[:page])
  end

  # GET /themes/1
  def show
  end

  # GET /themes/new
  def new
    @theme = Theme.new
    render layout: false
  end

  # GET /themes/1/edit
  def edit
    render layout: false
  end

  # POST /themes
  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      @themes = Theme.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /themes/1
  def update
    if @theme.update(theme_params)
      @themes = Theme.order(:code).paginate(page: params[:page])
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /themes/1
  def destroy
    dependent = []
    dependent << Activity.where(theme_id: @theme.id)
    dependent = dependent.flatten
    if dependent.blank?
      @theme.destroy
      redirect_to themes_url, notice: 'Theme successfully removed.'
    else
      redirect_to themes_url, alert: 'You cannot remove this theme. Please make sure it is not connected to other records before removing.'
    end
  end

  def audit
    theme = Theme.find(params[:id])
    @audits = []

    theme.audits.each do |a|
      a.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data 
        if val.class == Array
          changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
        else
          changes = ["N/A", val.to_s.humanize.capitalize]
        end
        if User.where(id: a.user_id).blank?
          user = "User does not exist"
        else
          user = a.user.display_name
        end
        @audits.push([a.created_at.to_date, a.action.capitalize, f, changes[0], changes[1], user])
      end
    end
    @audits = @audits.paginate(page: params[:page])
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def theme_params
      params.fetch(:theme, {}).permit(:code)
    end
end
