require 'spec_helper'

describe Member::Note do
  it 'has a valid factory' do
    expect(build(:member_note)).to be_valid
  end

  it 'is invalid without body' do
    expect(build(:member_note, body: nil)).to_not be_valid
  end
end
