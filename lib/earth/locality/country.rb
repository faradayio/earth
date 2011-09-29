class Country < ActiveRecord::Base
  set_primary_key :iso_3166_code
  
  has_many :rail_companies, :foreign_key => 'country_iso_3166_code'
  
  falls_back_on :name => 'fallback',
                :automobile_urbanity => lambda { Country.united_states.automobile_urbanity }, # for now assume US represents world
                :automobile_fuel_efficiency => ((22.5 + 16.2) / 2.0).miles_per_gallon.to(:kilometres_per_litre), # average of passenger car fuel unknown and light goods vehicle fuel unknown - WRI Mobile Combustion calculation tool v2.0
                :automobile_fuel_efficiency_units => 'kilometres_per_litre',
                :automobile_city_speed => lambda { Country.united_states.automobile_city_speed }, # for now assume US represents world
                :automobile_city_speed_units => lambda { Country.united_states.automobile_city_speed_units }, # for now assume US represents world
                :automobile_highway_speed => lambda { Country.united_states.automobile_highway_speed }, # for now assume US represents world
                :automobile_highway_speed_units => lambda { Country.united_states.automobile_highway_speed_units }, # for now assume US represents world
                :automobile_trip_distance => lambda { Country.united_states.automobile_trip_distance }, # for now assume US represents world
                :automobile_trip_distance_units => lambda { Country.united_states.automobile_trip_distance_units }, # for now assume US represents world
                :flight_route_inefficiency_factor => lambda { Country.maximum(:flight_route_inefficiency_factor) }, # default to the largest inefficiency factor
                :rail_trip_speed => lambda { Country.united_states.rail_speed }, # for now assume US represents world
                :rail_trip_speed_units => lambda { Country.united_states.rail_speed_units }, # for now assume US represents world
                :rail_trip_distance => lambda { Country.united_states.rail_distance }, # for now assume US represents world
                :rail_trip_distance_units => lambda { Country.united_states.rail_distance_units }, # for now assume US represents world
                :rail_trip_electricity_intensity => lambda { Country.united_states.rail_electricity_intensity }, # for now assume US represents world
                :rail_trip_electricity_intensity_units => lambda { Country.united_states.rail_electricity_intensity_units }, # for now assume US represents world
                :rail_trip_diesel_intensity => lambda { Country.united_states.rail_diesel_intensity }, # for now assume US represents world
                :rail_trip_diesel_intensity_units => lambda { Country.united_states.rail_diesel_intensity_units }, # for now assume US represents world
                :rail_trip_emission_factor => lambda { Country.united_states.rail_emission_factor }, # for now assume US represents world
                :rail_trip_emission_factor_units => lambda { Country.united_states.rail_emission_factor_units } # for now assume US represents world
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
  end
  
  def method_missing(method_id, *args, &block)
    if method_id.to_s =~ /\Arail_trip([^\?]+_units)\Z/
      scope = RailCompany.where(:country_iso_3166_code => iso_3166_code)
      target_units = $1.to_sym
      units_found = scope.map(&target_units).uniq
      if units_found.count == 1
        if units_found[0].present?
          units_found[0]
        else
          raise "All #{iso_3166_code} rail companies are missing #{target_units.to_s}!"
        end
      else
        raise "#{iso_3166_code} rail companies have multiple values for #{target_units.to_s}: #{units_found}"
      end
    elsif method_id.to_s =~ /\Arail_([^\?]+)\Z/
      attribute = $1.to_sym
      scope = RailCompany.where(:country_iso_3166_code => iso_3166_code)
      scope.weighted_average(attribute, :weighted_by => :passengers)
    else
      super
    end
  end
  
  col :iso_3166_code
  col :name
  col :automobile_urbanity, :type => :float
  col :automobile_fuel_efficiency, :type => :float
  col :automobile_fuel_efficiency_units
  col :automobile_city_speed, :type => :float
  col :automobile_city_speed_units
  col :automobile_highway_speed, :type => :float
  col :automobile_highway_speed_units
  col :automobile_trip_distance, :type => :float
  col :automobile_trip_distance_units
  col :flight_route_inefficiency_factor, :type => :float
  col :rail_trip_speed, :type => :float
  col :rail_trip_speed_units
  col :rail_trip_distance, :type => :float
  col :rail_trip_distance_units
  col :rail_trip_electricity_intensity, :type => :float
  col :rail_trip_electricity_intensity_units
  col :rail_trip_diesel_intensity, :type => :float
  col :rail_trip_diesel_intensity_units
  col :rail_trip_emission_factor, :type => :float
  col :rail_trip_emission_factor_units
end
