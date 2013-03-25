module Settings
  class MembersController < ApplicationController
    before_filter :member_settings

    def edit
    end

    def update
      if @member_settings.update_attributes(permitted_params)
        redirect_to edit_settings_member_url, flash: { success: 'Member Settings successfully updated.' }
      else
        render :edit
      end
    end

    private

    def permitted_params
      params.require(:settings_member).permit(:default_payment_due_day_enabled, :default_payment_due_day)
    end

    def member_settings
      if current_studio.member_settings?
        @member_settings ||= current_studio.member_settings
      else
        @member_settings ||= current_studio.create_member_settings
      end
    end
  end
end
