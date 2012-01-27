class LodgingFuelUseEquation < ActiveRecord::Base
  set_primary_key :name
  
  def self.find_by_criteria(fuel, criteria)
    first :conditions => {
      :fuel => fuel,
      :climate_zone_number => (criteria[:climate_zone_number].present? ? criteria[:climate_zone_number].value : nil), # FIXME TODO should be able to just do criteria[:climate_zone_number] but need to call a method on it b/c it's a Charisma object
      :property_rooms => (criteria[:property_rooms].present?),
      :construction_year => (criteria[:property_construction_year].present?)
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
