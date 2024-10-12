# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

if User.count < 100
  101.times do |n|
    User.create(
      email: Faker::Internet.email(name: Faker::Name.name),
      password: "password",
      password_confirmation: "password",
      name: Faker::Name.name
    )
  end
end
first_user = User.find_by(id: 1)
first_user.update(email: "user+0@example.com", uid: "user+0@example.com", password: "password", password_confirmation: "password") if first_user.present?

if Aircraft.count < 100
  puts "Seeding aircrafts with seats each!"

  101.times do |n|
    aircraft = Aircraft.create(
      name: Faker::Vehicle.make_and_model  # Tạo tên máy bay ngẫu nhiên
    )
    70.times do |n1|
      aircraft.seats.create!(seat_class: :economy)
    end
    20.times do |n2|
      aircraft.seats.create!(seat_class: :business)
    end
    10.times do |n3|
      aircraft.seats.create!(seat_class: :first_class)
    end
  end
end
first_aircraft = Aircraft.find_by(id: 1)
first_aircraft.update(name: "Boeing AT-15") if first_aircraft.present?

if Airport.count == 0
  puts "Seeding airports!"
  Airport.create(
    code: 'HAN',
    name: 'Noi Bai International Airport',
    country: 'Vietnam',
    city: 'Hanoi'
  )
  Airport.create(
    code: 'SGN',
    name: 'Tan Son Nhat International Airport',
    country: 'Vietnam',
    city: 'Ho Chi Minh City'
  )
  csv_file_path = Rails.root.join('db', 'seeds', 'airports.csv')

  CSV.foreach(csv_file_path, headers: true) do |row|
    Airport.create(
      code: row['code'],
      name: row['name'],
      country: row['country'],
      city: row['city']
    )
  end
end
first_airport = Airport.find_by(id: 1)
first_airport.update(code: 'HAN', name: 'Noi Bai International Airport', country: 'Vietnam', city: 'Hanoi') if first_airport.present?
second_airport = Airport.find_by(id: 2)
second_airport.update(code: 'SGN', name: 'Tan Son Nhat International Airport', country: 'Vietnam', city: 'Ho Chi Minh City') if second_airport.present?

if Administrator.count < 1
  Administrator.create(
    email: "administrator+0@example.com",
    password: "password",
    password_confirmation: "password",
    name: Faker::Name.name
  )
end
first_administrator = Administrator.find_by(id: 1)
first_administrator.update(email: "administrator+0@example.com", uid: "administrator+0@example.com", password: "password", password_confirmation: "password") if first_administrator.present?

if Flight.count == 0
  puts "Seeding flights with seat_availabilities + pricings each!"
  flight = Flight.create(
    aircraft_id: 1,
    departure_airport_id: 1,
    destination_airport_id: 2,
    departure_date: "2024-09-30T10:00:00Z",
    destination_date: "2024-09-30T20:00:00Z"
  )
  flight.generate_seat_availabilities
  Pricing.seat_classes.keys.each do |seat_class|
    flight.pricings.create(
      seat_class: seat_class,
      price: 100
    )
  end
  other_flight = Flight.create(
    aircraft_id: 1,
    departure_airport_id: 2,
    destination_airport_id: 1,
    departure_date: "2024-10-02T10:00:00Z",
    destination_date: "2024-10-02T20:00:00Z"
  )
  other_flight.generate_seat_availabilities
  Pricing.seat_classes.keys.each do |seat_class|
    other_flight.pricings.create(
      seat_class: seat_class,
      price: 100
    )
  end
end
first_flight = Flight.find_by(flight_id: 1)
if first_flight.present?
  first_flight.update(aircraft_id: 1,
    departure_airport_id: 1,
    destination_airport_id: 2,
    departure_date: "2024-09-30T10:00:00Z",
    destination_date: "2024-09-30T20:00:00Z")
end
second_flight = Flight.find_by(flight_id: 2)
if second_flight.present?
  second_flight.update(aircraft_id: 1,
    departure_airport_id: 2,
    destination_airport_id: 1,
    departure_date: "2024-10-02T10:00:00Z",
    destination_date: "2024-10-02T20:00:00Z")
end
