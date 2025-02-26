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

prime_annuelle = Benefit.create!(name: "Prime annuelle", recurrence: :yearly)
prime_anciennete = Benefit.create!(name: "Prime d'ancienneté", recurrence: :one_time)
prime_formation = Benefit.create!(name: "Prime de formation", recurrence: :one_time)

# Create rules

senior_paris_yearly = Rule.create!(name: "Seniority more than 6 years, Paris", amount: 2000, benefit: prime_annuelle)
senior_lyon_yearly = Rule.create!(name: "Seniority more than 6 years, Lyon", amount: 1500, benefit: prime_annuelle)
mid_paris_yearly = Rule.create!(name: "Seniority between 3 and 5 years, Paris", amount: 1000, benefit: prime_annuelle)
mid_lyon_yearly = Rule.create!(name: "Seniority between 3 and 5 years, Lyon", amount: 500, benefit: prime_annuelle)
intern_yearly = Rule.create!(name: "Stagiaire", amount: 100, benefit: prime_annuelle)
