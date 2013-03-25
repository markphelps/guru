module Settings
  class StudiosController < ApplicationController
    before_filter :studio

    def edit
    end

    def update
      if @studio.update_attributes(permitted_params)
        redirect_to edit_settings_studio_url, flash: { success: 'Studio was successfully updated.' }
      else
        render :edit
      end
    end

    private

    def permitted_params
      params.require(:studio).permit(:city, :email, :name, :phone, :state, :street_address, :zip, :time_zone)
    end

    def studio
      @studio ||= current_studio
    end
  end
end
