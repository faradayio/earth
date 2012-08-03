require 'earth/bus/bus_fuel_year_control'

FactoryGirl.define do
  factory :bfyc, :class => BusFuelYearControl do
    trait(:gas_2009_1) { name 'Gas 2009 tier 1'; bus_fuel_name 'gas'; year 2009 }
    trait(:gas_2010_1) { name 'Gas 2010 tier 1'; bus_fuel_name 'gas'; year 2010 }
    trait(:gas_2010_2) { name 'Gas 2010 tier 2'; bus_fuel_name 'gas'; year 2010 }
  end
end
