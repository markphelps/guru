require 'spec_helper'

describe Member do
  it 'has a valid factory' do
    expect(build(:member)).to be_valid
  end

  it 'is invalid without a firstname' do
    expect(build(:member, first_name: nil)).to_not be_valid
  end

  it 'is invalid without a lastname' do
    expect(build(:member, last_name: nil)).to_not be_valid
  end

  it "returns a member's full name as a string" do
    expect(build(:member, first_name: 'John', last_name: 'Doe').name).to eq 'John Doe'
  end

  it 'has default membership_type of monthly' do
    expect(build(:member, membership_type: nil).membership_type).to eq :monthly
  end

  it 'is invalid without price' do
    expect(build(:member, membership_price: nil)).to_not be_valid
  end

  it 'is invalid without start_date' do
    expect(build(:member, start_date: nil)).to_not be_valid
  end

  it 'is valid with a start_date but without an end_date' do
    expect(build(:member, start_date: Date.current, end_date: nil)).to be_valid
  end

  it 'is invalid if end_date is before start_date' do
    expect(build(:member, start_date: Date.current, end_date: Date.current << 1)).to_not be_valid
  end

  describe '#active' do
    it 'finds active members' do
      studio = create(:studio)
      active = create(:member, studio: studio)
      inactive = create(:member, active: false, studio: studio)

      expect(studio.members.active).to include active
      expect(studio.members.active).to_not include inactive
    end
  end

  describe '#inactive' do
    it 'finds inactive members' do
      studio = create(:studio)
      active = create(:member, studio: studio)
      inactive = create(:member, active: false, studio: studio)

      expect(studio.members.inactive).to_not include active
      expect(studio.members.inactive).to include inactive
    end
  end

  describe '#birthday' do
    it 'allows nil' do
      expect(build(:member, birthday: nil)).to be_valid
    end

    it 'allows blank' do
      expect(build(:member, birthday: '')).to be_valid
    end

    it 'must be before or on today' do
      expect(build(:member, birthday: Date.current >> 1)).to_not be_valid
    end
  end

  describe '#account?' do
    it 'can respond false' do
      expect(build(:member, account: nil).account?).to eq false
    end

    it 'can respond true' do
      expect(build(:member, account: build(:account)).account?).to eq true
    end
  end

  describe '#address?' do
    it 'returns false if all values nil' do
      expect(build(:member, street_address: nil, city: nil, state: nil, zip: nil).address?).to be_false
    end

    it 'returns false if all values empty' do
      expect(build(:member, street_address: '', city: '', state: '', zip: '').address?).to be_false
    end

    it 'returns true if address' do
      expect(build(:member, street_address: '123 Fake Street', city: nil, state: nil, zip: nil).address?).to be_true
    end
  end

  describe '.birthdays' do
    before :each do
      @studio = create(:studio)
      @member = create(:member, studio: @studio, birthday: Date.current)
    end

    it 'shows member birthdays in current month' do
      expect(@studio.members.birthdays).to include @member
    end

    it 'shows member birthdays in next month' do
      future = Date.current >> 1
      expect(@studio.members.birthdays(future.month)).to_not include @member
    end

    it 'shows member birthdays in previous month' do
      past = Date.current << 1
      expect(@studio.members.birthdays(past.month)).to_not include @member
    end
  end

  describe '.recent' do
    before :each do
      @studio = create(:studio)
      @member = create(:member, studio: @studio)
    end

    it 'finds newly created members' do
      expect(@studio.members.recent).to include @member
    end

    it 'defaults to 15 days ago' do
      Timecop.freeze(16.days.from_now) do
        expect(@studio.members.recent).to_not include @member
      end
    end

    it 'can take arbitrary date' do
      expect(@studio.members.recent(90.days.ago)).to include @member
    end
  end
end
