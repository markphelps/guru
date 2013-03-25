class Report::AccountReport
  include ActionView::Helpers::NumberHelper

  def initialize(studio, type = nil)
    @studio = studio
    @type = [:due, :up_to_date, :past_due].select { |x| x == type.to_sym unless type.nil? }.first || :all
  end

  def accounts
    case @type
    when :up_to_date
      @studio.accounts.up_to_date
    when :due
      @studio.accounts.due
    when :past_due
      @studio.accounts.past_due
    else
      @studio.accounts
    end
  end

  def name
    "#{@type.to_s.titleize} Accounts"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(First\ Name Last\ Name Status Membership\ Type Payment\ Due\ Date Balance)
      accounts.each do |account|
        csv << [account.member.first_name, account.member.last_name, account.status, account.member.membership_type.to_s.capitalize, account.payment_due_date.strftime('%m/%d/%Y'), number_to_currency(account.balance, unit: '')]
      end
    end
  end

  def filename
    "#{@type}_accounts.csv"
  end
end
