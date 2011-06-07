class AircraftFuelUseEquation < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'fuel_use_code', :primary_key => 'code'
  
  falls_back_on :m3 => lambda { weighted_average(:m3, :weighted_by => [:aircraft, :passengers]) }, # 9.73423082858437e-08   r7110: 8.6540464368905e-8      r6972: 8.37e-8
                :m2 => lambda { weighted_average(:m2, :weighted_by => [:aircraft, :passengers]) }, # -0.000134350543484608  r7110: -0.00015337661447817    r6972: -4.09e-5
                :m1 => lambda { weighted_average(:m1, :weighted_by => [:aircraft, :passengers]) }, # 6.7728101555467        r7110: 4.7781966869412         r6972: 7.85
                :b  => lambda { weighted_average(:b,  :weighted_by => [:aircraft, :passengers]) }, # 1527.81790006167       r7110: 1065.3476555284         r6972: 1.72e3
                :m3_units => 'kilograms_per_cubic_nautical_mile',
                :m2_units => 'kilograms_per_square_nautical_mile',
                :m1_units => 'kilograms_per_nautical_mile',
                :b_units  => 'kilograms'
  
  def fuel_use_coefficients
    [m3, m2, m1, b]
  end
  
  def valid_fuel_use_equation?
    fuel_use_coefficients.all?(&:present?) and fuel_use_coefficients.any?(&:nonzero?)
  end

  create_table do
    string 'code'
    string 'aircraft_description'
    float  'm3'
    string 'm3_units'
    float  'm2'
    string 'm2_units'
    float  'm1'
    string 'm1_units'
    float  'b'
    string 'b_units'
  end
  
  data_miner do
    # intentionally left blank.
  end
end
