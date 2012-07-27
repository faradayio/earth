require 'earth/model'
class ResidenceFuelType < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "residence_fuel_types"
  (
     "name"                  CHARACTER VARYING(255) NOT NULL,
     "emission_factor"       FLOAT,
     "emission_factor_units" CHARACTER VARYING(255)
  );
ALTER TABLE "residence_fuel_types" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :prices, :class_name => 'ResidenceFuelPrice', :foreign_key => 'residence_fuel_type_name'
  
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
