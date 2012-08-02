require 'earth/automobile/automobile_make_model_year'

FactoryGirl.define do
  factory :ammy, :class => AutomobileMakeModelYear do
    trait(:honda_civic_2000) { name 'Honda CIVIC 2000'; make_name 'Honda'; model_name 'CIVIC'; year 2000 }
    trait(:honda_civic_cng_2000) { name 'Honda CIVIC CNG 2000'; make_name 'Honda'; model_name 'CIVIC CNG'; year 2000 }
    trait(:honda_civic_cng_2001) { name 'Honda CIVIC CNG 2001'; make_name 'Honda'; model_name 'CIVIC CNG'; year 2001 }
  end
end
