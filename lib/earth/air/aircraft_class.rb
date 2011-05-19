class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'class_code', :primary_key => 'code'
  
  def fuel_use_coefficients
    [m3, m2, m1, b]
  end
  
  def valid_fuel_use_equation?
    fuel_use_coefficients.all?(&:present?) and fuel_use_coefficients.any?(&:nonzero?)
  end
  
  data_miner do
    tap "Brighter Planet's aircraft class data", Earth.taps_server
  end
end
