class ResidenceAppliance < ActiveRecord::Base
  self.primary_key = :name

  class << self
    def annual_energy_from_electricity_for(appliance_plural)
      appliance_name = appliance_plural.to_s.singularize
      if appliance = find_by_name(appliance_name)
        appliance.annual_energy_from_electricity
      end
    end
  end

  col :name
  col :annual_energy_from_electricity, :type => :float
  col :annual_energy_from_electricity_units
end
