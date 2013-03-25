require 'faker'

# Studio
Studio.delete_all
studio = Studio.create!(
  city: 'Durham',
  email: 'test@studiojoy.net',
  name: 'Test',
  phone: '(555) 555-5555',
  state: 'NC',
  street_address: Faker::Address.street_address,
  zip: Faker::Address.zip,
  time_zone: Time.zone.name
)

# Users
User.delete_all
User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  phone: '(555) 555-5555',
  email: 'test@studiojoy.net',
  password: 'password',
  studio: studio
)

# Klasses
Klass.delete_all
klasses = ['Expert Class', 'Intermediate Class', 'Open Class']
klasses.each do |klass|
  Klass.create!(
    day_of_week: Date::DAYNAMES[Random.new.rand(0..6)],
    class_time: Time.at(Time.now.to_i - (Time.now.to_i % 15.minutes)),
    name: klass,
    recurring: true,
    studio: studio
  )
end

# Levels
Level.delete_all
levels = ['Beginner', 'Master']
levels.each do |level|
  Level.create!(
    name: level,
    color: "##{Faker::Number.hexadecimal(6)}",
    studio: studio
  )
end

# Sources
Source.delete_all
sources = ['Facebook', 'Walk In', 'Referal']
sources.each do |source|
  Source.create!(
    name: source,
    studio: studio
  )
end

# Accounts
Account.delete_all

# Visits
Visit.delete_all

# Payments
Payment.delete_all

# Members
Member.delete_all
20.times do
  Member.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    phone: '(555) 555-5555',
    city: Faker::Address.city,
    state: Faker::Address.state,
    street_address: Faker::Address.street_address,
    zip: Faker::Address.zip,
    birthday: Faker::Date.birthday,
    active: true,
    start_date: Date.current,
    end_date: Date.current >> 12,
    membership_type: :monthly,
    membership_price: '50.00',
    studio: studio,
    level: Level.find_by_name(levels[Random.new.rand(0...levels.count)]),
    source: Source.find_by_name(sources[Random.new.rand(0...sources.count)])
  )
end