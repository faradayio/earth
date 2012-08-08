require 'earth/automobile/automobile_make'

FactoryGirl.define do
  factory :automobile_make, :class => AutomobileMake do
    trait(:ford) { name 'Ford' }
    trait(:honda) { name 'Honda' }
    trait(:vw) { name 'Volkswagen' }
  end
end
