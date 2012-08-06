require 'earth/fuel/fuel_year'

FactoryGirl.define do
  factory :fuel_year, :class => FuelYear do
    trait(:gas_2008) { name 'Gasoline 2008'; fuel_name 'Gasoline'; year 2008; energy_content 35; energy_content_units 'megajoules_per_litre'; carbon_content 18; carbon_content_units 'grams_per_megajoule'; co2_emission_factor 2.31; co2_emission_factor_units 'kilograms_per_litre'; co2_biogenic_emission_factor 0.0; co2_biogenic_emission_factor_units 'kilograms_per_litre' }
    trait(:gas_2007) { name 'Gasoline 2007'; fuel_name 'Gasoline'; year 2007; energy_content 35; energy_content_units 'megajoules_per_litre'; carbon_content 18; carbon_content_units 'grams_per_megajoule'; co2_emission_factor 2.31; co2_emission_factor_units 'kilograms_per_litre'; co2_biogenic_emission_factor 0.0; co2_biogenic_emission_factor_units 'kilograms_per_litre' }
  end
end
