class Member::Import
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :file

  validates :file, presence: true

  def initialize(studio, file = nil)
    @studio, @file = studio, file
  end

  def persisted?
    false
  end

  def save
    if imported_members.map(&:valid?).all?
      imported_members.each(&:save!)
      true
    else
      imported_members.each_with_index do |member, index|
        member.errors.full_messages.each do |message|
          errors.add :base, "Row #{index + 2}: #{message}"
        end
      end
      false
    end
  end

  def imported_members
    @imported_members ||= load_imported_members
  end

  def check_file
    fail 'No file provided' if file.nil?
    fail "Unknown file type: #{file.original_filename}" unless File.extname(file.original_filename) == '.csv'
  end

  def clean_attributes(attributes)
    attributes[:membership_type] = attributes[:membership_type].downcase! if attributes[:membership_type]
    attributes
  end

  def load_imported_members
    check_file
    members = []
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      member = @studio.members.find_by_id(row[:id]) || @studio.members.build
      member.attributes = clean_attributes(row.to_hash.slice(*self.class.importable_attributes))
      members << member
    end
    members
  end

  def self.importable_attributes
    [:first_name, :last_name, :phone, :email, :street_address, :city, :state, :zip, :birthday, :membership_type, :membership_price, :start_date, :end_date, :active]
  end
end
