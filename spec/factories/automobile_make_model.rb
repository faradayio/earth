require 'earth/automobile/automobile_make_model'

FactoryGirl.define do
  factory :amm, :class => AutomobileMakeModel do
    trait(:ford_f150_ffv) { name 'Ford F150 FFV'; make_name 'Ford'; model_name 'F150 FFV' }
    trait(:honda_civic_cng) { name 'Honda CIVIC CNG'; make_name 'Honda'; model_name 'CIVIC CNG' }
    trait(:vw_jetta) { name 'Volkswagen JETTA'; make_name 'Volkswagen'; model_name 'JETTA' }
    trait(:vw_jetta_diesel) { name 'Volkswagen JETTA DIESEL'; make_name 'Volkswagen'; model_name 'JETTA DIESEL' }
  end
end
