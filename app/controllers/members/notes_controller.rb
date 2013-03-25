module Members
  class NotesController < ApplicationController
    include ::MemberRequired
    before_filter :member
    before_filter :note, only: [:edit, :update, :destroy]

    def new
      @note = @member.notes.build
    end

    def create
      @note = @member.notes.build(permitted_params)
      if @note.save
        redirect_to @member, flash: { success: 'Note was successfully created.' }
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @note.update_attributes(permitted_params)
        redirect_to @member, flash: { success: 'Note was successfully updated.' }
      else
        render :edit
      end
    end

    def destroy
      if @note.destroy
        redirect_to @member, flash: { success: 'Note was successfully deleted.' }
      end
    end

    private

    def note
      @note = @member.notes.find(params[:id])
    end

    def permitted_params
      params.require(:member_note).permit(:body)
    end
  end
end
