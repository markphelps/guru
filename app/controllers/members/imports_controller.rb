module Members
  class ImportsController < ApplicationController
    def new
      @member_import = Member::Import.new(current_studio)
    end

    def create
      @member_import = Member::Import.new(current_studio, params[:member_import][:file])
      begin
        @member_import.save
        redirect_to members_url, flash: { success: 'Members imported successfully.' }
      rescue => e
        flash[:error] = e.message
        render :new
      end
    end
  end
end
