require 'earth/industry/industry'

FactoryGirl.define do
  factory :industry, :class => Industry do
    trait(:corn_farming) { naics_code 11115; description 'Corn farming' }
    trait(:retail_trade) { naics_code 44; description 'Retail trade' }
    trait(:wholesale_trade) { naics_code 42; description 'Wholesale trade' }
  end
end
