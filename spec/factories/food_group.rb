require 'earth/diet/food_group'

FactoryGirl.define do
  factory :food_group, :class => FoodGroup do
    trait(:meat) { name 'meat' }
    trait(:veg) { name 'veg' }
  end
end
