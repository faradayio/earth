require 'earth/industry/mecs_ratio'

FactoryGirl.define do
  factory :mecs_ratio, :class => MecsRatio do
    trait(:r11) { name '11'; naics_code 11; energy_per_dollar_of_shipments 0.1 }
    trait(:r11c1) { name '11-1'; naics_code 11; census_region_number 1; energy_per_dollar_of_shipments 0.1 }
    trait(:r111) { name '111'; naics_code 111; energy_per_dollar_of_shipments 0.1 }
    trait(:r111c1) { name '111-1';naics_code 111; census_region_number 1; energy_per_dollar_of_shipments 0.1 }
    trait(:r1111) { name '1111';naics_code 1111; energy_per_dollar_of_shipments 0.1 }
    trait(:r1111c1) { name '1111-1';naics_code 1111; census_region_number 1; energy_per_dollar_of_shipments 0.1 }
    trait(:r1111c2) { name '1111-2';naics_code 1111; census_region_number 2 }
    trait(:r1112) { name '1112';naics_code 1112; energy_per_dollar_of_shipments 0.1 }
    trait(:r1112c1) { name '1112-1';naics_code 1112; census_region_number 1; energy_per_dollar_of_shipments 0.1 }
  end
end
