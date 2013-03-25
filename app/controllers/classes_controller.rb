class ClassesController < ApplicationController
  include CsvExportable
  before_filter :klass, only: [:edit, :update, :destroy]

  def index
    @klasses = current_studio.klasses.page params[:page]
  end

  def export
    @klasses = current_studio.klasses.all
    export_csv Klass::CsvExport.new(@klasses)
  end

  def new
    @klass = current_studio.klasses.build
  end

  def create
    @klass = current_studio.klasses.build(permitted_params)
    if @klass.save
      redirect_to classes_url, flash: { success: 'Class was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @klass.update_attributes(permitted_params)
      redirect_to classes_url, flash: { success: 'Class was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @klass.destroy
      redirect_to classes_url, flash: { success: 'Class was successfully deleted.' }
    end
  end

  private

  def klass
    @klass = current_studio.klasses.find(params[:id])
  end

  def permitted_params
    params.require(:klass).permit(:day_of_week, :class_time, :name, :recurring)
  end
end
