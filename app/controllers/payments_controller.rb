class PaymentsController < InheritedResources::Base
  include AccountRequired
  include CsvExportable

  belongs_to :member
  belongs_to :account, singleton: :true
  actions :all, except: [:show, :edit, :update]
  custom_actions :collection => :export

  before_filter :check_account_exists

  def export
    export_csv Payment::CsvExport.new(@member)
  end

  def create
    create! { member_payments_url(@member) }
  end

  def destroy
    destroy! { member_payments_url(@member) }
  end

  protected

  def collection
    @payments ||= end_of_association_chain.page params[:page]
  end

  private

  def permitted_params
    params.permit(:member_id, payment: [:payment_date, :payment_amount, :due_date, :amount_due, :payment_method])
  end
end
