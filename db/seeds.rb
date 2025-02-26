# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
User.destroy_all
Benefit.destroy_all
# Create test users
User.create!(
  email: "senior.paris@example.com",
  password: "password",
  start_date: 7.years.ago,
  location: "Paris",
  contract_type: "CDI"
)

User.create!(
  email: "senior.lyon@example.com",
  password: "password",
  start_date: 7.years.ago,
  location: "Lyon",
  contract_type: "CDI"
)

User.create!(
  email: "mid.paris@example.com",
  password: "password",
  start_date: 4.years.ago,
  location: "Paris",
  contract_type: "CDI"
)

User.create!(
  email: "mid.lyon@example.com",
  password: "password",
  start_date: 4.years.ago,
  location: "Lyon",
  contract_type: "CDI"
)

User.create!(
  email: "intern@example.com",
  password: "password",
  start_date: 1.month.ago,
  location: "Paris",
  contract_type: "Stage"
)

