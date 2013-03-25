class LevelsController < ApplicationController
  include CsvExportable
  before_filter :level, only: [:edit, :update, :destroy]

  def index
    @levels = current_studio.levels.page params[:page]
  end

  def export
    @levels = current_studio.levels.all
    export_csv Level::CsvExport.new(@levels)
  end

  def new
    @level = current_studio.levels.build
  end

  def create
    @level = current_studio.levels.build(permitted_params)
    if @level.save
      redirect_to levels_url, flash: { success: 'Level was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @level.update_attributes(permitted_params)
      redirect_to levels_url, flash: { success: 'Level was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @level.destroy
      redirect_to levels_url, flash: { success: 'Level was successfully deleted.' }
    end
  end

  private

  def level
    @level = current_studio.levels.find(params[:id])
  end

  def permitted_params
    params.require(:level).permit(:name, :color)
  end
end
