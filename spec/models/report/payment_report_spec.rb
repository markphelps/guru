require 'spec_helper'

describe Report::PaymentReport do
  before :each do
    @studio = create(:studio)
    member = create(:member, studio: @studio)
    @account = create(:account, member: member)
  end

  it 'has monthly payment report' do
    create(:payment, account: @account)
    expect(Report::PaymentReport.new(@studio).payments.size).to_not be_empty
  end

  it 'filters dates for monthly payment report' do
    create(:payment, account: @account, payment_date: 2.years.ago)
    expect(Report::PaymentReport.new(@studio).payments.size).to be_empty
  end
end
