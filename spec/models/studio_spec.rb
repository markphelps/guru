require 'spec_helper'

describe Studio do
  it 'has a valid factory' do
    expect(build(:studio)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:studio, name: nil)).to_not be_valid
  end

  it 'is invalid without an email' do
    expect(build(:studio, email: nil)).to_not be_valid
  end

  it 'is invalid with a duplicate email address' do
    create(:studio, email: 'mark@example.com')
    studio = build(:studio, email: 'mark@example.com')
    expect(studio).to have(1).errors_on(:email)
  end

  it 'is invalid without a real timezone' do
    expect(build(:studio, time_zone: 'funtime')).to_not be_valid
  end

  it 'defaults time_zone to Eastern Time (US & Canada)' do
    expect(create(:studio).time_zone).to eq 'Eastern Time (US & Canada)'
  end

  describe '#address?' do
    it 'returns false if all values nil' do
      expect(build(:studio, street_address: nil, city: nil, state: nil, zip: nil).address?).to be_false
    end

    it 'returns false if all values empty' do
      expect(build(:studio, street_address: '', city: '', state: '', zip: '').address?).to be_false
    end

    it 'returns true if address' do
      expect(build(:studio, street_address: '123 Fake Street', city: nil, state: nil, zip: nil).address?).to be_true
    end
  end
end
