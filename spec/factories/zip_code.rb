require 'earth/locality/zip_code'

FactoryGirl.define do
  factory :zip_code, :class => ZipCode do
    trait(:zip1) { name 'test1'; latitude '50'; longitude '-75'; egrid_subregion_abbreviation 'CAMX' }
    trait(:zip2) { name 'test2'; latitude '50'; longitude '-75.1' }
    trait(:zip3) { name 'test3'; latitude '50'; longitude '-75.25' }
  end
end
