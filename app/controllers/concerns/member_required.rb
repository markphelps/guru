module MemberRequired
  extend ActiveSupport::Concern

  protected

  def member
    @member ||= current_studio.members.find(params[:member_id])
  end
end
