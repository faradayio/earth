require 'earth/automobile/automobile_fuel'

FactoryGirl.define do
  factory :automobile_fuel, :class => AutomobileFuel do
    trait(:b5) { name 'B5'; code 'BP-B5' }
    trait(:b20) { name 'B20'; code 'BP-B20' }
    trait(:b100) { name 'B100'; code 'BP-B100' }
    trait(:cng) { name 'CNG'; code 'C'; energy_content_units 'megajoules_per_cubic_metre' }
    trait(:diesel) { name 'diesel'; code 'D'; total_consumption 100 }
    trait(:e85) { name 'E85'; code 'E' }
    trait(:gas) { name 'gasoline'; code 'G'; energy_content_units 'megajoules_per_litre'; total_consumption 900 }
    trait(:regular) { name 'regular gas'; code 'R' }
    trait(:premium) { name 'premium gas'; code 'P' }
  end
end
