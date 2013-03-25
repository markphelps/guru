require 'spec_helper'

describe Visit do
  it 'has a valid factory' do
    expect(build(:visit)).to be_valid
  end

  it 'is invalid without visit_date' do
    expect(build(:visit, visit_date: nil)).to_not be_valid
  end
end
