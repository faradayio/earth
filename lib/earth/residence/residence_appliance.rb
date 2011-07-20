class ResidenceAppliance < ActiveRecord::Base
  set_primary_key :name

  class << self
    def annual_energy_from_electricity_for(appliance_plural)
      appliance_name = appliance_plural.to_s.singularize
      if appliance = find_by_name(appliance_name)
        appliance.annual_energy_from_electricity
      end
    end
  end

  force_schema do
    string   'name'
    float    'annual_energy_from_electricity'
    string   'annual_energy_from_electricity_units'
  end
end
