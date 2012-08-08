require 'earth/electricity/green_button_adoption'

FactoryGirl.define do
  factory :green_button_adoption, :class => GreenButtonAdoption do
    trait(:committed_utility) { electric_utility_name 'A committed utility'; implemented nil; committed 1 }
    trait(:implemented_utility) { electric_utility_name 'An implemented utility'; implemented 1; committed nil }
  end
end
