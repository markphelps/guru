require 'spec_helper'

describe Member::Import do
  let(:file) { File.new("#{Rails.root}/spec/factories/uploads/members.csv") }

  before :each do
    @studio = build(:studio)
  end

  it 'is invalid without file' do
    expect(Member::Import.new(@studio)).to_not be_valid
  end

  describe '#persisted?' do
    it 'is false' do
      expect(Member::Import.new(@studio, file).persisted?).to be_false
    end
  end

  describe '#clean_attributes' do
    it 'can handle capitalized membership_type' do
      attributes = Member::Import.new(@studio, file).clean_attributes(membership_type: 'Monthly')
      expect(attributes[:membership_type]).to eq 'monthly'
    end
  end

  describe '#load_imported_members' do
    it 'throws error if file is nil' do
      expect { Member::Import.new(@studio, nil).load_imported_members }.to raise_error
    end

    it 'throws error if file is not a csv' do
      file = double(:check_file)
      allow(file).to receive(:path).and_return('test.txt')
      allow(file).to receive(:original_filename).and_return('test.txt')
      expect { Member::Import.new(@studio, file).load_imported_members }.to raise_error
    end

    it 'loads valid csv file correctly' do
      member_import = Member::Import.new(@studio, file)
      member_import.stub(:check_file)
      members = member_import.load_imported_members
      expect(members).to_not be_empty
      member = members.first
      expect(member).to be_an_instance_of(Member)
      expect(member.name).to eq 'Mark Phelps'
      expect(member.membership_price).to eq 50.0
    end
  end
end
