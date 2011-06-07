class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'class_code', :primary_key => 'code'
  
  def fuel_use_coefficients
    [m3, m2, m1, b]
  end
  
  def valid_fuel_use_equation?
    fuel_use_coefficients.all?(&:present?) and fuel_use_coefficients.any?(&:nonzero?)
  end

  create_table do
    string 'code'
    float  'm3'
    string 'm3_units'
    float  'm2'
    string 'm2_units'
    float  'm1'
    string 'm1_units'
    float  'b'
    string 'b_units'
    float  'seats'
  end
  
  data_miner do
    # intentionally left blank.
  end
end
