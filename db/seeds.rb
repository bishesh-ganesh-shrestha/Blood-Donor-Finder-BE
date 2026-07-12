# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# frozen_string_literal: true

# puts "Cleaning database..."

# Notification.destroy_all
# BloodDonationRequest.destroy_all
# BloodRequest.destroy_all
# DonorProfile.destroy_all
# User.destroy_all

puts "Creating seed data..."

BLOOD_GROUPS = %w[
  A+
  A-
  B+
  B-
  AB+
  AB-
  O+
  O-
].freeze

FIRST_NAMES = %w[
  Aarav Aayush Bishesh Ram Hari Krishna
  Prakash Nabin Roshan Ramesh Anil Sunil
  Sabin Sujan Sagar Bikash Manoj Santosh
  Kiran Bibek Dipesh Milan Ujjwal Suraj
  Niraj Keshav Bimal Prabin Jenish Rubin
  Nischal Ashish
  Sita Gita Ritu Priya Sneha
  Anisha Pooja Alisha Samiksha
  Rojina Swastika Prerana Smriti
].freeze

LAST_NAMES = %w[
  Shrestha Sharma Karki KC Poudel
  Gautam Rai Gurung Tamang Thapa
  Magar Bhandari Maharjan Acharya
].freeze

KATHMANDU_LOCATIONS = [
  { name: "New Baneshwor", latitude: 27.6887, longitude: 85.3356 },
  { name: "Koteshwor", latitude: 27.6788, longitude: 85.3498 },
  { name: "Kalanki", latitude: 27.6936, longitude: 85.2817 },
  { name: "Maharajgunj", latitude: 27.7394, longitude: 85.3318 },
  { name: "Balaju", latitude: 27.7304, longitude: 85.2956 },
  { name: "Thamel", latitude: 27.7154, longitude: 85.3123 },
  { name: "Boudha", latitude: 27.7215, longitude: 85.3616 },
  { name: "Patan", latitude: 27.6710, longitude: 85.3256 },
  { name: "Jawalakhel", latitude: 27.6739, longitude: 85.3148 },
  { name: "Bhaktapur", latitude: 27.6710, longitude: 85.4298 },
  { name: "Kirtipur", latitude: 27.6667, longitude: 85.2778 },
  { name: "Sankhu", latitude: 27.7296, longitude: 85.4570 },
  { name: "Gongabu", latitude: 27.7362, longitude: 85.3147 },
  { name: "Chabahil", latitude: 27.7218, longitude: 85.3453 },
  { name: "Satdobato", latitude: 27.6589, longitude: 85.3240 }
].freeze

HOSPITALS = [
  "Teaching Hospital",
  "Bir Hospital",
  "Civil Hospital",
  "Grande Hospital",
  "Norvic Hospital",
  "Patan Hospital",
  "Mediciti Hospital",
  "Star Hospital"
].freeze

users = []

puts "Creating users..."

50.times do |i|
  first = FIRST_NAMES.sample
  last = LAST_NAMES.sample

  users << User.create!(
    name: "#{first} #{last}",
    email: "user#{i + 1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    phone_number: "98#{format('%08d', i + 10000000)}"
  )
end

puts "#{User.count} users created."

puts "Creating donor profiles..."

donor_users = users.sample(42)

donor_users.each_with_index do |user, index|
  location = KATHMANDU_LOCATIONS.sample

  DonorProfile.create!(
    user: user,
    blood_group: BLOOD_GROUPS[index % BLOOD_GROUPS.length],
    available: [ true, true, true, false ].sample,
    verified: [ true, true, true, false ].sample,
    latitude: location[:latitude],
    longitude: location[:longitude],
    location: location[:name],
    last_active_at: rand(5..180).minutes.ago,
    last_donated_at: rand(4..12).months.ago
  )
end

puts "#{DonorProfile.count} donor profiles created."

puts "Creating blood requests..."

request_users = users - donor_users

8.times do
  requester = request_users.sample || users.sample
  location = KATHMANDU_LOCATIONS.sample

  BloodRequest.create!(
    user: requester,
    patient_name: "#{FIRST_NAMES.sample} #{LAST_NAMES.sample}",
    blood_group: BLOOD_GROUPS.sample,
    hospital_name: HOSPITALS.sample,
    contact_number: "98#{rand(10000000..99999999)}",
    urgency: %w[normal urgent critical].sample,
    status: "open",
    units_required: rand(1..4),
    units_collected: 0,
    latitude: location[:latitude],
    longitude: location[:longitude]
  )
end

puts "#{BloodRequest.count} blood requests created."

puts "--------------------------------------"
puts "Users              : #{User.count}"
puts "Donor Profiles     : #{DonorProfile.count}"
puts "Blood Requests     : #{BloodRequest.count}"
puts "Notifications      : #{Notification.count}"
puts "--------------------------------------"
puts "Seed completed successfully!"
