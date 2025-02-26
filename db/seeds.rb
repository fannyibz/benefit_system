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


# Create benefits

# Create benefits
senior_paris = Benefit.create!(name: "Senior Paris Benefit", amount: 2000)
senior_other = Benefit.create!(name: "Senior Other Location Benefit", amount: 1500)
mid_paris = Benefit.create!(name: "Mid-level Paris Benefit", amount: 1000)
mid_other = Benefit.create!(name: "Mid-level Other Location Benefit", amount: 500)
intern = Benefit.create!(name: "Intern Benefit", amount: 100)
