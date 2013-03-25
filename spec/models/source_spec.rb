require 'spec_helper'

describe Source do
  it 'has a valid factory' do
    expect(build(:source)).to be_valid
  end

  it 'is invalid without name' do
    expect(build(:source, name: nil)).to_not be_valid
  end

  it 'must have a unique name per studio' do
    source = create(:source, name: 'test')
    expect(build(:source, name: source.name, studio: source.studio)).to_not be_valid
  end

  it 'can have a non-unique name for different studio' do
    source = create(:source, name: 'test')
    expect(build(:source, name: source.name)).to be_valid
  end
end
