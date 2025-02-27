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
UserBenefit.destroy_all
Rule.destroy_all
Benefit.destroy_all
User.destroy_all

# Create test users
user_1 = User.create!(
  first_name: "Iris",
  last_name: "Leroy",
  email: "senior.paris@example.com",
  password: "password",
  start_date: 5.years.ago + 2.days,
  location: "Paris",
  contract_type: "CDI"
)

user_2 = User.create!(
  first_name: "Mathieu",
  last_name: "Dumont",
  email: "senior.lyon@example.com",
  password: "password",
  start_date: 7.years.ago,
  location: "Lyon",
  contract_type: "CDI"
)

user_3 = User.create!(
  first_name: "Flora",
  last_name: "Moreira",
  email: "mid.paris@example.com",
  password: "password",
  start_date: 4.years.ago,
  location: "Paris",
  contract_type: "CDI"
)

user_4 = User.create!(
  first_name: "Louis",
  last_name: "Deltour",
  email: "mid.lyon@example.com",
  password: "password",
  start_date: 4.years.ago,
  location: "Lyon",
  contract_type: "CDI"
)

user_5 = User.create!(
  first_name: "Claire",
  last_name: "Mussat",
  email: "intern@example.com",
  password: "password",
  start_date: 1.month.ago,
  location: "Paris",
  contract_type: "Stage"
)


# Create benefits

prime_annuelle = Benefit.create!(
  name: "Prime annuelle",
  recurrence: :yearly
)

prime_anciennete = Benefit.create!(
  name: "Prime d'ancienneté",
  recurrence: :one_time
)

prime_formation = Benefit.create!(
  name: "Prime de formation",
  recurrence: :one_time
)

# Create rules for "Prime annuelle"

senior_paris_yearly = Rule.create!(
  name: "Seniority more than 6 years, Paris",
  amount: 2000,
  benefit: prime_annuelle,
  conditions: { min_seniority: 6, location: "Paris" }
)

senior_lyon_yearly = Rule.create!(
  name: "Seniority more than 6 years, Lyon",
  amount: 1500,
  benefit: prime_annuelle,
  conditions: { min_seniority: 6, location: "Lyon" }
)

mid_paris_yearly = Rule.create!(
  name: "Seniority between 3 and 5 years, Paris",
  amount: 1000,
  benefit: prime_annuelle,
  conditions: { min_seniority: 3, max_seniority: 5, location: "Paris" }
)

mid_lyon_yearly = Rule.create!(
  name: "Seniority between 3 and 5 years, Lyon",
  amount: 500,
  benefit: prime_annuelle,
  conditions: { min_seniority: 3, max_seniority: 5, location: "Lyon" }
)

intern_yearly = Rule.create!(
  name: "Stagiaire",
  amount: 100,
  benefit: prime_annuelle,
  conditions: { contract_type: "Stage" }
)

seniority_5_years = Rule.create!(
  name: "Seniority more than 5 years",
  amount: 2000,
  benefit: prime_anciennete,
  conditions: { min_seniority: 5 }
)

# Create rules for "Prime d'ancienneté"

seniority_4_years = Rule.create!(
  name: "Ancienneté 4 ans",
  amount: 1000,
  benefit: prime_anciennete,
  conditions: { min_seniority: 4 }
)

seniority_8_years = Rule.create!(
  name: "Ancienneté 8 ans",
  amount: 2000,
  benefit: prime_anciennete,
  conditions: { min_seniority: 8 }
)

# Create rules for "Prime de formation"

formation_cdi_seniority_4_years = Rule.create!(
  name: "Formation CDI, ancienneté 4 ans",
  amount: 1000,
  benefit: prime_formation,
  conditions: { contract_type: "CDI", min_seniority: 4 }
)

# Create user benefits

matching_rule = prime_annuelle.matching_benefit_rule_for(user_1)
user_benefit_1 = UserBenefit.create!(
  user: user_1,
  rule: matching_rule,
  benefit: prime_annuelle,
  amount: matching_rule.amount,
  status: :active,
  granted_at: Time.current.beginning_of_year
)

matching_rule = prime_anciennete.matching_benefit_rule_for(user_1)
user_benefit_2 = UserBenefit.create!(
  user: user_1,
  rule: matching_rule,
  benefit: prime_anciennete,
  amount: matching_rule.amount,
  status: :active,
  granted_at: user_1.start_date + 4.years
)
