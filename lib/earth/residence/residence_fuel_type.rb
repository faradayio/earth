class ResidenceFuelType < ActiveRecord::Base
  set_primary_key :name
  
  has_many :prices, :class_name => 'ResidenceFuelPrice', :foreign_key => 'residence_fuel_type_name'
  
  force_schema do
    string   'name'
    float    'emission_factor'
    string   'emission_factor_units'
    # float    'energy_content'
    # string   'energy_content_units'
  end
  
  def price_per_unit(relaxations = [])
    conditions = { :residence_fuel_type_name => self }
    relaxations.push Hash.new
    relaxations.grab do |relaxation|
      relaxation_conditions = Hash.new
      if timeframe = relaxation[:timeframe]
        relaxation_conditions[:year] = timeframe.from.year
        relaxation_conditions[:month] = timeframe.from.month..timeframe.to.yesterday.month
      end
      if location = relaxation[:location]
        relaxation_conditions[:locatable_type] = location.class.to_s
        relaxation_conditions[:locatable_id] = location.id
      end
      ResidenceFuelPrice.average :price, :conditions => conditions.merge(relaxation_conditions)
    end
  end

  class << self
    def [](fuel)
      find_by_name fuel.to_s.humanize.downcase
    end
  end
end
