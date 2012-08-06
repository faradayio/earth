require 'earth/rail/national_transit_database_company'

FactoryGirl.define do
  factory :ntd_company, :class => NationalTransitDatabaseCompany do
    trait(:rail_company) { id 'muni'; name 'SF muni ' }
    trait(:bus_company) { id 'gg'; name 'Golden gate transit' }
  end
end
