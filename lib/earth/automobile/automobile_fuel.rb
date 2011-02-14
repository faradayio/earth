class AutomobileFuel < ActiveRecord::Base
  set_primary_key :code
  
  scope :ordered, :order => 'name'
  
  has_many :automobile_type_fuel_ages,  :foreign_key => 'fuel_common_name', :primary_key => 'distance_fuel_common_name'
  has_many :automobile_type_fuel_years, :foreign_key => 'fuel_common_name', :primary_key => 'ef_fuel_common_name'
  belongs_to :base_fuel,                :foreign_key => 'base_fuel_name',  :class_name => 'Fuel'
  belongs_to :blend_fuel,               :foreign_key => 'blend_fuel_name', :class_name => 'Fuel'
  
  class << self
    def fallback_blend_portion
      latest_year = AutomobileTypeFuelYear.maximum('year')
      gas_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'gasoline').sum('fuel_consumption')
      diesel_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'diesel').sum('fuel_consumption')
      diesel_use / (gas_use + diesel_use)
    end
  end
  
  falls_back_on :name => 'fallback',
                :base_fuel_name => 'Motor Gasoline',
                :blend_fuel_name => 'Distillate Fuel Oil No. 2',
                :blend_portion => lambda { AutomobileFuel.fallback_blend_portion },
                :distance_fuel_common_name => 'fallback',
                :ef_fuel_common_name => 'fallback'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile fuel type data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  # calculates the average distance traveled by all ages and vehicle types using the distance_fuel_common_name, weighted by vehicles
  def annual_distance
    scope = automobile_type_fuel_ages.any? ? automobile_type_fuel_ages : AutomobileTypeFuelAge
    scope.weighted_average(:annual_distance, :weighted_by => :vehicles)
  end
  
  # returns kg co2 / litre
  def co2_emission_factor
    base_fuel_ef = (base_fuel.energy_content * base_fuel.carbon_content * base_fuel.oxidation_factor * (1 - base_fuel.biogenic_fraction)).grams.to(:kilograms).carbon.to(:co2)
    if blend_fuel.nil?
      base_fuel_ef
    else
      blend_fuel_ef = (blend_fuel.energy_content * blend_fuel.carbon_content * blend_fuel.oxidation_factor * (1 - blend_fuel.biogenic_fraction)).grams.to(:kilograms).carbon.to(:co2)
      (base_fuel_ef * (1 - blend_portion)) + (blend_fuel_ef * blend_portion)
    end
  end
  
  # returns kg co2 / litre
  def co2_biogenic_emission_factor
    base_fuel_ef = (base_fuel.energy_content * base_fuel.carbon_content * base_fuel.oxidation_factor * base_fuel.biogenic_fraction).grams.to(:kilograms).carbon.to(:co2)
    if blend_fuel.nil?
      base_fuel_ef
    else
      blend_fuel_ef = (blend_fuel.energy_content * blend_fuel.carbon_content * blend_fuel.oxidation_factor * blend_fuel.biogenic_fraction).grams.to(:kilograms).carbon.to(:co2)
      (base_fuel_ef * (1 - blend_portion)) + (blend_fuel_ef * blend_portion)
    end
  end
  
  def latest_type_fuel_years
    scope = automobile_type_fuel_years.any? ? automobile_type_fuel_years : AutomobileTypeFuelYear
    scope.where(:year => scope.maximum('year'))
  end
  
  # returns kg co2e / litre
  def ch4_emission_factor
    latest_type_fuel_years.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:ch4].global_warming_potential
  end
  
  # returns kg co2e / litre
  def n2o_emission_factor
    latest_type_fuel_years.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:n2o].global_warming_potential
  end
  
  # returns kg co2e / litre (hfc emission factor is already in co2e)
  def hfc_emission_factor
    latest_type_fuel_years.weighted_average(:hfc_emission_factor, :weighted_by => :total_travel)
  end
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
