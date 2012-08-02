require 'earth/automobile/automobile_activity_year'

FactoryGirl.define do
  factory :aay, :class => AutomobileActivityYear do
    trait(:twenty_nine) { activity_year 2009; }
    trait(:twenty_ten) { activity_year 2010; }
  end
end
