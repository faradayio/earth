require 'earth/fuel'
class NationalTransitDatabaseRecord < ActiveRecord::Base
  self.primary_key = :name
  self.table_name = :ntd_records
  
  belongs_to :ntd_company, :foreign_key => 'company_id', :class_name => 'NationalTransitDatabaseCompany'
  
  def self.rail_records
    where(:mode_code => NationalTransitDatabaseMode.rail_modes)
  end
  
  col :name
  col :company_id
  col :mode_code
  col :service_type
  col :vehicle_distance, :type => :float
  col :vehicle_distance_units
  col :vehicle_time, :type => :float
  col :vehicle_time_units
  col :passenger_distance, :type => :float
  col :passenger_distance_units
  col :passengers, :type => :float
  col :electricity, :type => :float
  col :electricity_units
  col :diesel, :type => :float
  col :diesel_units
  col :gasoline, :type => :float
  col :gasoline_units
  col :lpg, :type => :float
  col :lpg_units
  col :lng, :type => :float
  col :lng_units
  col :cng, :type => :float
  col :cng_units
  col :kerosene, :type => :float
  col :kerosene_units
  col :biodiesel, :type => :float
  col :biodiesel_units
  col :other_fuel, :type => :float
  col :other_fuel_units
  col :other_fuel_description
end
