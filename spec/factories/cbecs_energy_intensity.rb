require 'earth/industry/cbecs_energy_intensity'

FactoryGirl.define do
  factory :cbecs_energy_intensity, :class => CbecsEnergyIntensity do
    trait(:i11) { name '11'; naics_code 11 }
    trait(:i1111) { name '1111'; naics_code 1111 }
    trait(:i1112) { name '1112'; naics_code 1112 }
    trait(:i11r1) { name '11-1'; naics_code 11; census_region_number 1 }
    trait(:i1111r1) { name '1111-1'; naics_code 1111; census_region_number 1 }
    trait(:i1112r1) { name '1112-1'; naics_code 1112; census_region_number 1 }
    trait(:i11d1) { name '11-1-1'; naics_code 11; census_region_number 1; census_division_number 1 }
    trait(:i1111d1) { name '1111-1-1'; naics_code 1111; census_region_number 1; census_division_number 1 }
    trait(:i1112d1) { name '1112-1-1'; naics_code 1112; census_region_number 1; census_division_number 1 }
  end
end
