class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  belongs_to :aircraft_class, :foreign_key => 'aircraft_class_code'
  belongs_to :manufacturer,   :foreign_key => 'manufacturer_name',                  :class_name => 'AircraftManufacturer'
  has_many   :segments,       :foreign_key => 'bts_aircraft_type_code',             :class_name => "FlightSegment", :primary_key => 'bts_aircraft_type_code'

  falls_back_on :m3 =>                      lambda { weighted_average(:m3,             :weighted_by => [:segments, :passengers]) }, # 9.73423082858437e-08   r7110: 8.6540464368905e-8      r6972: 8.37e-8
                :m2 =>                      lambda { weighted_average(:m2,             :weighted_by => [:segments, :passengers]) }, # -0.000134350543484608  r7110: -0.00015337661447817    r6972: -4.09e-5
                :m1 =>                      lambda { weighted_average(:m1,             :weighted_by => [:segments, :passengers]) }, # 6.7728101555467        r7110: 4.7781966869412         r6972: 7.85
                :endpoint_fuel =>           lambda { weighted_average(:endpoint_fuel,  :weighted_by => [:segments, :passengers]) }, # 1527.81790006167       r7110: 1065.3476555284         r6972: 1.72e3
                :seats =>                   lambda { weighted_average(:seats,          :weighted_by => [:segments, :passengers]) } # 62.1741

  data_miner do
    tap "Brighter Planet's sanitized aircraft data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
