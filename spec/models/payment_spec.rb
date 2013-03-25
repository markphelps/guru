require 'spec_helper'

describe Payment do
  it 'has a valid factory' do
    expect(build(:payment)).to be_valid
  end

  it 'is invalid without amount_due' do
    expect(build(:payment, amount_due: nil)).to_not be_valid
  end

  it 'is invalid without payment_amount' do
    expect(build(:payment, payment_amount: nil)).to_not be_valid
  end

  it 'is invalid without due_date' do
    expect(build(:payment, due_date: nil)).to_not be_valid
  end

  it 'is invalid without payment_date' do
    expect(build(:payment, payment_date: nil)).to_not be_valid
  end

  it 'has default payment_method of check' do
    expect(Payment.new.payment_method).to eq :check
  end

  describe '.recent' do
    it 'returns payments with payment_date within past 90 days' do
      payment = create(:payment)
      expect(Payment.recent).to include payment
    end

    it 'doesnt return payments with payment_date more than 90 days ago' do
      payment = create(:payment, payment_date: 91.days.ago)
      expect(Payment.recent).to_not include payment
    end
  end

  describe '.for_month' do
    it 'returns payments with payment_date within given month' do
      payment = create(:payment)
      expect(Payment.for_month).to include payment
    end

    it 'doesnt return payments not within given month' do
      payment = create(:payment, payment_date: Date.current << 1)
      expect(Payment.for_month).to_not include payment
    end

    it 'only returns payments for the given year' do
      payment = create(:payment)
      expect(Payment.for_month(Date.current.month, Date.current.year - 1)).to_not include payment
    end
  end
end
