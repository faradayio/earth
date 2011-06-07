class AircraftManufacturer < ActiveRecord::Base
  set_primary_key :name

  create_table do
    string 'name'
  end
end
