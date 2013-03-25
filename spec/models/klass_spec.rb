require 'spec_helper'

describe Klass do
  it 'has a valid factory' do
    expect(build(:klass)).to be_valid
  end

  it 'is invalid without class_time' do
    expect(build(:klass, class_time: nil)).to_not be_valid
  end

  it 'is invalid without name' do
    expect(build(:klass, name: nil)).to_not be_valid
  end

  it 'is invalid with name > 30 characters' do
    expect(build(:klass, name: 'a' * 31)).to_not be_valid
  end

  it 'is valid with name <= 30 characters' do
    expect(build(:klass, name: 'a' * 30)).to be_valid
  end

  it 'is invalid without day_of_week' do
    expect(build(:klass, day_of_week: nil)).to_not be_valid
  end

  it 'is invalid without valid day_of_week' do
    expect(build(:klass, day_of_week: 'Funday')).to_not be_valid
  end

  describe '#name_and_time' do
    before :each do
      @klass = build(:klass)
    end

    it 'should include class name' do
      expect(@klass.name_and_time).to include @klass.name
    end

    it 'should include class time' do
      expect(@klass.name_and_time).to include @klass.class_time.in_time_zone.strftime("%-l:%M %p")
    end
  end

  describe '#name_day_and_time' do
    before :each do
      @klass = build(:klass)
    end

    it 'should include class day_of_week' do
      expect(@klass.name_day_and_time).to include @klass.day_of_week
    end

    it 'should include class name' do
      expect(@klass.name_day_and_time).to include @klass.name
    end

    it 'should include class time' do
      expect(@klass.name_day_and_time).to include @klass.class_time.in_time_zone.strftime("%-l:%M %p")
    end
  end

  describe '.for_day_of_week' do
    before :each do
      @studio = create(:studio)
    end

    it 'should default to today' do
      klass = create(:klass, studio: @studio, day_of_week: Date.current.strftime('%A'))
      expect(@studio.klasses.for_day_of_week).to include klass
    end

    it 'should return classes for other days' do
      tomorrow = Date.current + 1
      klass = create(:klass, studio: @studio, day_of_week: tomorrow.strftime('%A'))
      expect(@studio.klasses.for_day_of_week(tomorrow.wday)).to include klass
    end

    it 'should return empty array if no classes' do
      expect(@studio.klasses.for_day_of_week).to be_empty
    end
  end

  describe '.today' do
    before :each do
      @studio = create(:studio)
    end

    it 'should return classes for today' do
      klass = create(:klass, studio: @studio, day_of_week: Date.current.strftime('%A'))
      expect(@studio.klasses.today).to include klass
    end

    it 'should return empty array if no classes' do
      expect(@studio.klasses.today).to be_empty
    end
  end
end
