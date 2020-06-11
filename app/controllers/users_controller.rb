class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.order(:email).paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
    render layout: false
  end

  # GET /users/1/edit
  def edit
    render layout: false
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      @users = User.order(:email).paginate(page: params[:page])
      render 'update_success'
    else
      render 'create_failure'
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      @users = User.order(:email).paginate(page: params[:page])
      render 'update_success'
    else
      render 'update_failure'
    end
  end

  # DELETE /users/1
  def destroy
    if @user == current_user
      redirect_to users_url, alert: 'You cannot remove yourself.'
    else  
      dependent = []
      dependent << Activity.where(user_id: @user.id)
      dependent << ActivityTeaching.where(user_id: @user.id)
      dependent << ActivityTech.where(tech_lead_id: @user.id)
      dependent << ActivityTech.where(tech_ustudy_id: @user.id)
      dependent << GtaInvite.where(user_id: @user.id)
      dependent << UniModule.where(user_id: @user.id)
      dependent = dependent.flatten
      if dependent.blank?
        @user.destroy
        redirect_to users_url, notice: 'User successfully removed.'
      else
        redirect_to users_url, alert: 'You cannot remove this user. Please make sure they are not connected to other records before removing.'
      end
    end
  end

  def audit
    user = User.find(params[:id])
    @audits = []

    user.audits.each do |a|
      a.audited_changes.each do |field, val|
        f = field.to_s.humanize.capitalize
        # Format data
        if field == "role"
          if val.class == Array
            changes = [User.role_strings[val[0]], User.role_strings[val[1]]]
          else
            changes = ["N/A", User.role_strings[val]]
          end
        else   
          if val.class == Array
            changes = [val[0].to_s.humanize.capitalize, val[1].to_s.humanize.capitalize]
          else
            changes = ["N/A", val.to_s.humanize.capitalize]
          end
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
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {}).permit(:email, :display_name, :role, :analyst, :super_user)
    end
end
