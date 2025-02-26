FactoryBot.define do
  factory :benefit do
    name { "Prime annuelle" }
    recurrence { :yearly }
  end
end 