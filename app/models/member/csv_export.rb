class Member::CsvExport
  include ActionView::Helpers::NumberHelper

  def initialize(members)
    @members = members
  end

  def filename
    'members.csv'
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Id First\ Name Last\ Name Phone Email Level Street\ Address City State Zip Birthday Membership\ Type Membership\ Price Start\ Date End\ Date Date\ Added Active)
      @members.each do |member|
        csv << [member.id, member.first_name, member.last_name, member.phone, member.email, member.try(:level).try(:name), member.street_address, member.city, member.state, member.zip, member.try(:birthday).try(:strftime, '%m/%d/%Y'), member.membership_type.to_s.capitalize, number_to_currency(member.membership_price, unit: ''),  member.try(:start_date).try(:strftime, '%m/%d/%Y'),  member.try(:end_date).try(:strftime, '%m/%d/%Y'), member.created_at.strftime('%m/%d/%Y'), member.active]
      end
    end
  end
end
