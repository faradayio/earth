class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'class_code', :primary_key => 'code'
  
  def fuel_use_coefficients
    [m3, m2, m1, b]
  end
  
  def valid_fuel_use_equation?
    fuel_use_coefficients.all?(&:present?) and fuel_use_coefficients.any?(&:nonzero?)
  end
  
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
end