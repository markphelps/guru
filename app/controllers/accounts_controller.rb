class AccountsController < ApplicationController
  include AccountRequired
  before_filter :member
  before_filter :check_account_doesnt_exist, only: [:new, :create]

  def new
    @account = @member.build_account
  end

  def create
    @account = @member.build_account(permitted_params)
    if @account.valid?
      @account.update_status
      @account.save
      redirect_to @member, flash: { success: 'Account was successfully created.' }
    else
      render :new
    end
  end

  def edit
    @account = @member.account
  end

  def update
    @account = @member.account
    @account.assign_attributes(permitted_params)
    if @account.valid?
      @account.update_status
      @account.save
      redirect_to @member, flash: { success: 'Account was successfully updated.' }
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:account).permit(:balance, :payment_due_date)
  end
end
