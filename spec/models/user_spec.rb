require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it "returns a user's full name as a string" do
    user = build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end

  it 'is invalid without an email' do
    expect(build(:user, email: nil)).to_not be_valid
  end

  it 'is invalid with a duplicate email address' do
    create(:user, email: 'mark@example.com')
    user = build(:user, email: 'mark@example.com')
    expect(user).to have(1).errors_on(:email)
  end

  describe '#can_destroy?' do
    it 'responds false if owner' do
      expect(build(:user, owner: true).can_destroy?).to be_false
    end

    it 'responds false if only user' do
      expect(create(:user).can_destroy?).to be_false
    end

    it 'responds true if otherwise' do
      user = create(:user)
      create(:user, studio: user.studio)
      expect(user.can_destroy?).to be_true
    end
  end
end
