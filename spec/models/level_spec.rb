require 'spec_helper'

describe Level do
  it 'has a valid factory' do
    expect(build(:level)).to be_valid
  end

  it 'is invalid without name' do
    expect(build(:level, name: nil)).to_not be_valid
  end

  it 'must have a unique name per studio' do
    level = create(:level, name: 'test')
    expect(build(:level, name: level.name, studio: level.studio)).to_not be_valid
  end

  it 'can have a non-unique name for different studio' do
    level = create(:level, name: 'test')
    expect(build(:level, name: level.name)).to be_valid
  end

  it 'is invalid with a non-hex color' do
    expect(build(:level, color: '#1')).to_not be_valid
  end

  it 'is invalid with a color that does not start with #' do
    expect(build(:level, color: '111111')).to_not be_valid
  end

  it 'is valid with a valid hex color' do
    expect(build(:level, color: '#ffffff')).to be_valid
  end
end
