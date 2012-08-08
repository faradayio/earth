require 'earth/automobile/automobile_model'

FactoryGirl.define do
  factory :automobile_model, :class => AutomobileModel do
    trait(:civic) { name 'Civic' }
    trait(:f150) { name 'F150' }
    trait(:jetta) { name 'Jetta' }
  end
end
