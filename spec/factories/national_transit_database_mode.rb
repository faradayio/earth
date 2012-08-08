require 'earth/rail/national_transit_database_mode'

FactoryGirl.define do
  factory :ntd_mode, :class => NationalTransitDatabaseMode do
    trait(:rail) { code 'R'; name 'Rail'; rail_mode true }
    trait(:bus) { code 'B'; name 'Bus'; rail_mode false }
  end
end
