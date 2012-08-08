require 'earth/automobile/automobile_type_fuel_control'

FactoryGirl.define do
  factory :atfc, :class => AutomobileTypeFuelControl do
    trait(:car_tier_1) {
      name 'cars gas tier 1';
      type_name 'cars';
      fuel_family 'gas';
      control_name 'tier 1';
      ch4_emission_factor 0.04;
      ch4_emission_factor_units 'kilograms_co2e_per_kilometre';
      n2o_emission_factor 0.08;
      n2o_emission_factor_units 'kilograms_co2e_per_kilometre'
    }
  end
end
