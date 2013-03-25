require 'spec_helper'

describe Account do
  it 'has a valid factory' do
    expect(build(:account)).to be_valid
  end

  describe '#now_up_to_date?' do
    it 'returns true if zero_balance? and !due_date_passed?' do
      expect(build(:due_account, balance: 0).now_up_to_date?).to be_true
    end

    it 'returns true if zero_balance? and due_date_passed?' do
      expect(build(:past_due_account, balance: 0).now_up_to_date?).to be_true
    end

    it 'returns false if owes? and !due_date_passed?' do
      expect(build(:due_account).now_up_to_date?).to be_false
    end

    it 'returns false if owes? and due_date_passed?' do
      expect(build(:past_due_account).now_up_to_date?).to be_false
    end
  end

  describe '#now_due?' do
    it 'returns true if owes? and !due_date_passed?' do
      expect(build(:up_to_date_account, balance: 10).now_due?).to be_true
    end

    it 'returns false if zero_balance? and !due_date_passed?' do
      expect(build(:up_to_date_account).now_due?).to be_false
    end

    it 'returns false if owes? and due_date_passed?' do
      expect(build(:past_due_account).now_due?).to be_false
    end

    it 'returns false if zero_balance? and due_date_passed?' do
      expect(build(:past_due_account, balance: 0).now_due?).to be_false
    end
  end

  describe '#now_past_due?' do
    it 'returns true if owes? and due_date_passed?' do
      expect(build(:due_account, payment_due_date: Date.current - 1).now_past_due?).to be_true
    end

    it 'returns false if zero_balance and due_date_passed?' do
      expect(build(:up_to_date_account, payment_due_date: Date.current - 1).now_past_due?).to be_false
    end

    it 'returns false if owes? and !due_date_passed?' do
      expect(build(:due_account).now_past_due?).to be_false
    end

    it 'returns false if zero_balance and !due_date_passed?' do
      expect(build(:up_to_date_account).now_past_due?).to be_false
    end
  end

  describe '#status' do
    it 'can say due' do
      expect(build(:due_account).status).to eq 'Due'
    end

    it 'can say past_due' do
      expect(build(:past_due_account).status).to eq 'Past Due'
    end

    it 'can say up_to_date' do
      expect(build(:up_to_date_account).status).to eq 'Up To Date'
    end
  end

  describe '#color' do
    it 'has a color for due' do
      expect(build(:due_account).color).to eq '#9c9c9c'
    end

    it 'has a color for past_due' do
      expect(build(:past_due_account).color).to eq '#ff6c60'
    end

    it 'has a color for up_to_date' do
      expect(build(:up_to_date_account).color).to eq '#41cac0'
    end
  end

  describe '#payment_made!' do
    it 'subtracts from balance' do
      account = build(:due_account, balance: 51.00)
      account.payment_made! 50.00
      expect(account.balance).to eq 1.00
    end

    it 'stays due if owes? and state was due' do
      account = build(:due_account, balance: 51.00)
      account.payment_made! 50.00
      expect(account.due?).to be_true
    end

    it 'moves to up_to_date if balance <= 0 and state was due' do
      account = build(:due_account, balance: 50.00)
      account.payment_made! 50.00
      expect(account.up_to_date?).to be_true
    end

    it 'stays past_due state if owes? and state was past_due' do
      account = build(:past_due_account, balance: 51.00)
      account.payment_made! 50.00
      expect(account.past_due?).to be_true
    end

    it 'moves to up_to_date if balance <= 0 and state was past_due' do
      account = build(:past_due_account, balance: 50.00)
      account.payment_made! 50.00
      expect(account.up_to_date?).to be_true
    end

    it 'stays up_to_date if balance <= 0 and state was up_to_date' do
      account = build(:up_to_date_account)
      account.payment_made! 50.00
      expect(account.up_to_date?).to be_true
    end
  end

  describe '#payment_deleted!' do
    it 'adds to balance' do
      account = build(:account, balance: 0)
      account.payment_deleted! 50.00
      expect(account.balance).to eq 50.00
    end

    it 'stays due if owes? and state was due' do
      account = build(:due_account, balance: 1.00)
      account.payment_deleted! 50.00
      expect(account.due?).to be_true
    end

    it 'moves to due if owes? and state was up_to_date' do
      account = build(:up_to_date_account, balance: 0)
      account.payment_deleted! 50.00
      expect(account.due?).to be_true
    end

    it 'stays in past_due if owes? and state was past_due' do
      account = build(:past_due_account, balance: 1.00)
      account.payment_deleted! 50.00
      expect(account.past_due?).to be_true
    end
  end

  describe '#owes?' do
    it 'returns false if balance == 0' do
      expect(build(:account, balance: 0).owes?).to be_false
    end

    it 'returns false if balance < 0' do
      expect(build(:account, balance: -10).owes?).to be_false
    end

    it 'returns true if balance > 0' do
      expect(build(:account, balance: 10).owes?).to be_true
    end
  end

  describe '#zero_balance?' do
    it 'returns true if balance == 0' do
      expect(build(:account, balance: 0).zero_balance?).to be_true
    end

    it 'returns true if balance < 0' do
      expect(build(:account, balance: -10).zero_balance?).to be_true
    end

    it 'returns false if balance > 0' do
      expect(build(:account, balance: 10).zero_balance?).to be_false
    end
  end

  describe '#due_date_passed?' do
    it 'returns true if due_date < today' do
      expect(build(:account, payment_due_date: Date.current - 1).due_date_passed?).to be_true
    end

    it 'returns false if due_date == today' do
      expect(build(:account, payment_due_date: Date.current).due_date_passed?).to be_false
    end

    it 'returns false if due_date > today' do
      expect(build(:account, payment_due_date: Date.current + 1).due_date_passed?).to be_false
    end
  end

  describe '#last_payment' do
    it 'can retrieve last_payment' do
      account = create(:account)
      create(:payment, account: account)
      last_payment = create(:payment, account: account)
      expect(account.last_payment).to eq last_payment
    end
  end

  describe '#next_payment_due_date' do
    it 'returns next_payment_due_date for weekly members' do
      member = build(:member, membership_type: :weekly)
      account = build(:account, payment_due_date: Date.current, member: member)
      expect(account.next_payment_due_date).to eq(Date.current + 7)
    end

    it 'returns next payment_due_date for monthly members' do
      account = build(:account, payment_due_date: Date.current)
      expect(account.next_payment_due_date).to eq(Date.current >> 1)
    end

    it 'returns next payment_due_date for annual members' do
      member = build(:member, membership_type: :annual)
      account = build(:account, payment_due_date: Date.current, member: member)
      expect(account.next_payment_due_date).to eq(Date.current >> 12)
    end

    it 'returns existing payment_due_date for visit members' do
      member = build(:member, membership_type: :visit)
      account = build(:account, payment_due_date: Date.current, member: member)
      expect(account.next_payment_due_date).to eq(Date.current)
    end
  end

  describe '#default_payment_amount' do
    it 'returns the account balance if owes?' do
      account = build(:due_account)
      expect(account.owes?).to be_true
      expect(account.default_payment_amount).to eq account.balance
    end

    it 'returns 0 if zero_balance?' do
      account = build(:up_to_date_account)
      expect(account.zero_balance?).to be_true
      expect(account.default_payment_amount).to eq 0
    end
  end

  describe '.default_payment_due_date' do
    it 'returns today if member_settings default_payment_due_day is not enabled' do
      studio = create(:studio)
      create(:settings_member, studio: studio, default_payment_due_day_enabled: false)
      expect(Account.default_payment_due_date(studio)).to eq Date.current
    end
    it 'returns default_payment_due_day for current month if default_payment_due_day is enabled' do
      Timecop.freeze(Date.new(2014, 7, 19)) do
        studio = create(:studio)
        create(:settings_member, studio: studio, default_payment_due_day_enabled: true, default_payment_due_day: 15)
        default_payment_due_date = Account.default_payment_due_date(studio)
        expect(default_payment_due_date).to_not eq Date.current
        expect(default_payment_due_date.day).to eq 15
        expect(default_payment_due_date.year).to eq 2014
        expect(default_payment_due_date.month).to eq 7
      end
    end
  end

  describe '.due' do
    it 'finds accounts with payments due' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:due_account, member: member)
      expect(studio.accounts.due.count).to eq 1
    end
  end

  describe '.past_due' do
    it 'finds accounts with payments past_due' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:past_due_account, member: member)
      expect(studio.accounts.past_due.count).to eq 1
    end
  end

  describe '.up_to_date' do
    it 'finds up_to_date accounts' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:up_to_date_account, member: member)
      expect(studio.accounts.up_to_date.count).to eq 1
    end
  end

  describe '.due_today' do
    it 'finds accounts due today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:up_to_date_account, balance: 1.00, member: member)
      expect(studio.accounts.due_today.count).to eq 1
    end

    it 'doesnt find accounts past_due today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:due_account, payment_due_date: Date.current - 1, member: member)
      expect(studio.accounts.due_today.count).to eq 0
    end

    it 'doesnt find accounts up_to_date today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:up_to_date_account, payment_due_date: Date.current - 1, member: member)
      expect(studio.accounts.due_today.count).to eq 0
    end

    it 'doesnt find accounts that were already due' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:due_account, member: member)
      expect(studio.accounts.due_today.count).to eq 0
    end
  end

  describe '.past_due_today' do
    it 'finds accounts past_due today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:due_account, payment_due_date: Date.current - 1, member: member)
      expect(studio.accounts.past_due_today.count).to eq 1
    end

    it 'doesnt find accounts due today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:up_to_date_account, balance: 1.00, member: member)
      expect(studio.accounts.past_due_today.count).to eq 0
    end

    it 'doesnt find accounts up_to_date today' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:up_to_date_account, payment_due_date: Date.current - 1, member: member)
      expect(studio.accounts.past_due_today.count).to eq 0
    end

    it 'doesnt find accounts that were already past_due' do
      studio = create(:studio)
      member = create(:member, studio: studio)
      create(:past_due_account, member: member)
      expect(studio.accounts.past_due_today.count).to eq 0
    end
  end

  describe '#update_status' do
    it 'changes status to due if owes? and due_date has not passed' do
      account = create(:account, balance: 1.00)
      account.update_status
      expect(account.due?).to be_true
    end

    it 'changes status to past_due if owes? and due_date has passed' do
      account = create(:account, balance: 1.00, payment_due_date: Date.current - 1)
      account.update_status
      expect(account.past_due?).to be_true
    end

    it 'changes status to up_to_date if zero_balance' do
      account = create(:account, balance: 0)
      account.update_status
      expect(account.up_to_date?).to be_true
    end
  end
end
