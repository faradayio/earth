class AutomobileTypeYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :automobile_type_fuel_years, :foreign_key => 'type_year_name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type year data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  # AutomobileFuel needs this to calculate weighted average hfc emission factor
  def total_travel
    automobile_type_fuel_years.map(&:total_travel).sum
  end
  
  def hfc_emission_factor
    hfc_emissions / automobile_type_fuel_years.map(&:fuel_consumption).sum
  end
  
  def hfc_emission_factor_units
    "kilograms_co2e_per_litre"
  end
end
