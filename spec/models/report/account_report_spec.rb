require 'spec_helper'

describe Report::AccountReport do
  before :each do
    @studio = create(:studio)
    @member = create(:member, studio: @studio)
  end

  describe '#accounts' do
    it 'defaults to all accounts' do
      create(:account, member: @member)
      expect(Report::AccountReport.new(@studio).accounts).to_not be_empty
    end

    it 'can return up_to_date accounts' do
      create(:up_to_date_account, member: @member)
      expect(Report::AccountReport.new(@studio, :up_to_date).accounts).to_not be_empty
    end

    it 'can return due accounts' do
      create(:due_account, member: @member)
      expect(Report::AccountReport.new(@studio, :due).accounts).to_not be_empty
    end

    it 'can return past_due accounts' do
      create(:past_due_account, member: @member)
      expect(Report::AccountReport.new(@studio, :past_due).accounts).to_not be_empty
    end
  end

  describe '#filename' do
    it 'defaults to contain all_accounts' do
      expect(Report::AccountReport.new(@studio).filename).to include 'all_accounts'
    end
  end
end
