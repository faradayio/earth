class ResidenceFuelType < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :prices, :class_name => 'ResidenceFuelPrice', :foreign_key => 'residence_fuel_type_name'
  
  col :name
  col :emission_factor, :type => :float
  col :emission_factor_units
  # col :energy_content, :type => :float
  # col :energy_content_units
  
  def price_per_unit(relaxations = [])
    conditions = { :residence_fuel_type_name => self }
    relaxations.push Hash.new
    relaxations.each do |relaxation|
      relaxation_conditions = Hash.new
      if timeframe = relaxation[:timeframe]
        relaxation_conditions[:year] = timeframe.from.year
        relaxation_conditions[:month] = timeframe.from.month..timeframe.to.yesterday.month
      end
      if location = relaxation[:location]
        relaxation_conditions[:locatable_type] = location.class.to_s
        relaxation_conditions[:locatable_id] = location.id
      end
      if non_nil_result = ResidenceFuelPrice.average(:price, :conditions => conditions.merge(relaxation_conditions))
        return non_nil_result
      end
    end
    nil
  end

  class << self
    def [](fuel)
      find_by_name fuel.to_s.humanize.downcase
    end
  end

  warn_unless_size 7
end
