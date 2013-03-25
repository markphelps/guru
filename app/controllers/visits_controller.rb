class VisitsController < ApplicationController
  include MemberRequired
  include CsvExportable
  before_filter :member
  before_filter :visit, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        visits = []
        @member.visits.each do |v|
          visits << { id: v.id, title: v.klass.name_and_time, start: v.visit_date.strftime('%Y-%m-%d'), end: v.visit_date.strftime('%Y-%m-%d'), url: edit_member_visit_path(@member, v) } unless v.klass.nil?
        end
        render json: visits
      end
    end
  end

  def export
    export_csv Visit::CsvExport.new(@member)
  end

  def new
    @visit = @member.visits.build
  end

  def create
    @visit = @member.visits.build(permitted_params)
    if @visit.save
      redirect_to member_visits_url(@member), flash: { success: 'Visit was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @visit.update_attributes(permitted_params)
      redirect_to member_visits_url(@member), flash: { success: 'Visit was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @visit.destroy
      redirect_to member_visits_url(@member), flash: { success: 'Visit was successfully deleted.' }
    end
  end

  private

  def visit
    @visit = @member.visits.find(params[:id])
  end

  def permitted_params
    params.require(:visit).permit(:visit_date, :klass_id, :member_id)
  end
end
