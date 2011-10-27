class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'class_code', :primary_key => 'code'

  col :code
  col :m3, :type => :float
  col :m3_units
  col :m2, :type => :float
  col :m2_units
  col :m1, :type => :float
  col :m1_units
  col :b, :type => :float
  col :b_units
  col :seats, :type => :float
  
  def fuel_use_coefficients
    [m3, m2, m1, b]
  end
  
  def valid_fuel_use_equation?
    fuel_use_coefficients.all?(&:present?) and fuel_use_coefficients.any?(&:nonzero?)
  end
  
  class << self
    def update_averages!
      Aircraft.run_data_miner!
      AircraftFuelUseEquation.run_data_miner!
      find_each do |aircraft_class|
        cumulative_passengers = 0
        aircraft_class.m3 = 0.0
        aircraft_class.m2 = 0.0
        aircraft_class.m1 = 0.0
        aircraft_class.b = 0.0
      
        aircraft_class.aircraft.where('passengers > 0 AND fuel_use_code IS NOT NULL').each do |a|
          cumulative_passengers += a.passengers
          aircraft_class.m3 += a.fuel_use_equation.m3 * a.passengers
          aircraft_class.m2 += a.fuel_use_equation.m2 * a.passengers
          aircraft_class.m1 += a.fuel_use_equation.m1 * a.passengers
          aircraft_class.b += a.fuel_use_equation.b * a.passengers
        end
      
        if cumulative_passengers > 0
          aircraft_class.m3 /= cumulative_passengers
          aircraft_class.m2 /= cumulative_passengers
          aircraft_class.m1 /= cumulative_passengers
          aircraft_class.b /= cumulative_passengers
        end
      
        aircraft_class.seats = aircraft_class.aircraft.weighted_average(:seats, :weighted_by => :passengers)
      
        aircraft_class.m3_units = 'kilograms_per_cubic_nautical_mile'
        aircraft_class.m2_units = 'kilograms_per_square_nautical_mile'
        aircraft_class.m1_units = 'kilograms_per_nautical_mile'
        aircraft_class.b_units  = 'kilograms'
      
        aircraft_class.save!
      end
    end
  end
end
