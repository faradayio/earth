require 'earth/electricity/electric_utility'

FactoryGirl.define do
  factory :electric_utility, :class => ElectricUtility do
    trait(:committed_utility) { eia_id 1; name 'ACU'; nickname 'A committed utility' }
    trait(:implemented_utility) { eia_id 2; name 'AIU'; nickname 'An implemented utility' }
  end
end
