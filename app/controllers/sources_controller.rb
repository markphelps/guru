class SourcesController < ApplicationController
  include CsvExportable
  before_filter :source, only: [:edit, :update, :destroy]

  def index
    @sources = current_studio.sources.page params[:page]
  end

  def export
    @sources = current_studio.sources.all
    export_csv Source::CsvExport.new(@sources)
  end

  def new
    @source = current_studio.sources.build
  end

  def create
    @source = current_studio.sources.build(permitted_params)
    if @source.save
      redirect_to sources_url, flash: { success: 'Source successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @source.update_attributes(permitted_params)
      redirect_to sources_url, flash: { success: 'Source successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @source.destroy
      redirect_to sources_url, flash: { success: 'Source successfully deleted.' }
    end
  end

  private

  def source
    @source = current_studio.sources.find(params[:id])
  end

  def permitted_params
    params.require(:source).permit(:name)
  end
end
