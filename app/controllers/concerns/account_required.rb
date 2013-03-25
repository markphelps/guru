module AccountRequired
  extend ActiveSupport::Concern
  include MemberRequired

  protected

  def check_account_exists
    redirect_to new_member_account_url(member), flash: { alert: "Account not found for #{member.name}. Please create one." } unless member.account?
  end

  def check_account_doesnt_exist
    redirect_to member, flash: { alert: "An account already exists for #{member.name}." } if member.account?
  end
end

