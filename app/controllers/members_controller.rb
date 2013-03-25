class MembersController < ApplicationController
  include CsvExportable
  before_filter :member, only: [:edit, :update, :show, :destroy]

  def index
    if params[:query].present?
      @members = current_studio.members.search(params[:query], page: params[:page], where: { studio_id: current_studio.id })
    else
      @members = current_studio.members.page params[:page]
    end
  end

  def export
    @members = current_studio.members.all
    export_csv Member::CsvExport.new(@members)
  end

  def active
    @members = current_studio.members.active.page params[:page]
    @title = 'Active Members'
    render :index
  end

  def inactive
    @members = current_studio.members.inactive.page params[:page]
    @title = 'Inactive Members'
    render :index
  end

  def new
    @member = current_studio.members.build
  end

  def create
    @member = current_studio.members.build(permitted_params)
    if @member.save
      redirect_to @member, flash: { success: 'Member was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @member.update_attributes(permitted_params)
      redirect_to @member, flash: { success: 'Member was successfully updated.' }
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    if @member.destroy
      redirect_to members_url, flash: { success: 'Member was successfully deleted.' }
    end
  end

  def destroy_multiple
    if Member.destroy(params[:members])
      redirect_to members_url, flash: { success: 'Members successfully deleted.' }
    else
      redirect_to members_url
    end
  end

  private

  def member
     @member = current_studio.members.find(params[:id])
  end

  def permitted_params
    params.require(:member).permit(:active, :birthday, :city, :email, :first_name, :last_name, :phone, :state, :street_address, :zip, :image, :image_cache, :remove_image, :notes, :start_date, :end_date, :membership_price, :membership_type, :level_id, :source_id)
  end
end
