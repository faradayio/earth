require 'earth/fuel/fuel'

FactoryGirl.define do
  factory :fuel, :class => Fuel do
    trait(:diesel) { name 'Diesel'; energy_content 39; energy_content_units 'megajoules_per_litre'; carbon_content 19; carbon_content_units 'grams_per_megajoule'; co2_emission_factor 2.717; co2_emission_factor_units 'kilograms_per_litre'; co2_biogenic_emission_factor 0.0; co2_biogenic_emission_factor_units 'kilograms_per_litre' }
    trait(:gas) { name 'Gasoline' }
  end
end
