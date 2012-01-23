class LodgingFuelUseEquation < ActiveRecord::Base
  set_primary_key :name
  
  def self.find_by_criteria(fuel, criteria)
    first :conditions => {
      :fuel => fuel,
      :climate_zone_number => (criteria[:climate_zone_number].present? ? criteria[:climate_zone_number].value : nil),
      :property_rooms => (criteria[:property_rooms].present? ? 1 : 0),
      :construction_year => (criteria[:property_construction_year].present? ? 1 : 0)
    }
  end
  
  col :name
  col :regression
  col :fuel
  col :climate_zone_number, :type => :integer
  col :property_rooms,      :type => :boolean
  col :construction_year,   :type => :boolean
  col :rooms_factor,        :type => :float
  col :year_factor,         :type => :float
  col :constant,            :type => :float
  col :units
  col :oil_share,           :type => :float
  col :gas_share,           :type => :float
  col :steam_share,         :type => :float
end
