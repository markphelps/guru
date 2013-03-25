require 'spec_helper'

describe Settings::Member do
  it 'has a valid factory' do
    expect(build(:settings_member)).to be_valid
  end

  describe 'default_payment_due_day validation' do
    it 'must be greater than 0' do
      expect(build(:settings_member, default_payment_due_day: -1)).to_not be_valid
      expect(build(:settings_member, default_payment_due_day: 1)).to be_valid
    end

    it 'must be less than or equal to 31' do
      expect(build(:settings_member, default_payment_due_day: 32)).to_not be_valid
      expect(build(:settings_member, default_payment_due_day: 31)).to be_valid
    end

    it 'must be an integer' do
      expect(build(:settings_member, default_payment_due_day: 15.5)).to_not be_valid
    end
  end

  describe '.current_month_payment_due_day' do
    it 'returns last day of month if less than default_payment_due_day' do
      Timecop.freeze(Date.new(2014, 2, 1)) do
        # mock date as February (28 days)
        expect(build(:settings_member, default_payment_due_day: 31).current_month_payment_due_day).to eq 28
      end
    end

    it 'returns default_payment_due_day if less than last day of month' do
      Timecop.freeze(Date.new(2014, 2, 1)) do
        # mock date as February (28 days)
        expect(build(:settings_member, default_payment_due_day: 15).current_month_payment_due_day).to eq 15
      end
    end
  end
end
