class ResidenceFuelType < ActiveRecord::Base
  set_primary_key :name
  
  has_many :prices, :class_name => 'ResidenceFuelPrice', :foreign_key => 'residence_fuel_type_name'
  
  data_miner do
    tap "Brighter Planet's residence fuel types data", Earth.taps_server
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
