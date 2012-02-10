Fuel.class_eval do
  data_miner do
    process "Ensure FuelYear is populated" do
      FuelYear.run_data_miner!
    end
    
    process "Derive fuel names from FuelYear" do
      ::Earth::Utils.insert_ignore(
        :src => FuelYear,
        :dest => Fuel,
        :cols => { :fuel_name => :name }
      )
    end
    
    import "fuels with non-variable characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGJmYkdtajZyV3Byb0lrd21xLVhXUGc&hl=en&gid=0&output=csv' do
      key 'name'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    import "densities for aircraft fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHBjTVE4NmRlc05iUHVZR1E3eEJwOGc&hl=en&gid=0&output=csv' do
      key 'name'
      store 'density', :units_field_name => 'density_units'
    end
    
    process "Convert energy content of liquid fuels to metric units" do
      conversion_factor = (1_055.05585) * (1.0 / 158.987295) # Google: 1_055.05585 MJ / 1 MMBtu * 1 barrel / 158.987295 l
      where(:energy_content_units => 'million_btu_per_barrel').update_all(%{
        energy_content = 1.0 * energy_content * #{conversion_factor},
        energy_content_units = 'megajoules_per_litre'
      })
    end
    
    process "Convert energy content of gaseous fuels to metric units" do
      conversion_factor = (1.0 / 947.81712) * (35.3146667) # Google: 1.0 MJ / 947.81712 Btu * 35.3146667 cubic feet / 1 cubic m
      where(:energy_content_units => 'btu_per_cubic_foot').update_all(%{
        energy_content = 1.0 * energy_content * #{conversion_factor},
        energy_content_units = 'megajoules_per_cubic_metre'
      })
    end
    
    process "Convert carbon content to metric units" do
      conversion_factor = (1_000_000_000_000.0) * (1.0 / 1_055_055_852_620.0) # Google: 1e12 g / Tg * 1 QBtu / 1.055e12 MJ
      where(:carbon_content_units => 'teragrams_per_quadrillion_btu').update_all(%{
        carbon_content = 1.0 * carbon_content * #{conversion_factor},
        carbon_content_units = 'grams_per_megajoule'
      })
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1.0 / 1_000.0) * (44.0 / 12.0) # Google: 1 kg / 1e3 g * 44 CO2 / 12 C
      update_all(%{
        co2_emission_factor = 1.0 * carbon_content * energy_content * oxidation_factor * (1 - biogenic_fraction) * #{conversion_factor},
        co2_biogenic_emission_factor = 1.0 * carbon_content * energy_content * oxidation_factor * biogenic_fraction * #{conversion_factor}
      })
    end
    
    process "Update emission factor units for liquid fuels" do
      where(:energy_content_units => 'megajoules_per_litre').update_all(
        :co2_emission_factor_units => 'kilograms_per_litre',
        :co2_biogenic_emission_factor_units => 'kilograms_per_litre'
      )
    end
    
    process "Update emission factor units for gaseous fuels" do
      where(:energy_content_units => 'megajoules_per_cubic_metre').update_all(
        :co2_emission_factor_units => 'kilograms_per_cubic_metre',
        :co2_biogenic_emission_factor_units => 'kilograms_per_cubic_metre'
      )
    end
    
    process "Calcualte data for distrct heat" do
      natural_gas = find_by_name 'Pipeline Natural Gas'
      natural_gas_energy_ef = natural_gas.co2_emission_factor / natural_gas.energy_content
      
      fuel_oil = find_by_name 'Residual Fuel Oil No. 6'
      fuel_oil_energy_ef = fuel_oil.co2_emission_factor / fuel_oil.energy_content
      
      district_heat = find_or_create_by_name "District Heat"
      district_heat.oxidation_factor = 1
      district_heat.biogenic_fraction = 0
      district_heat.co2_biogenic_emission_factor = 0
      district_heat.co2_biogenic_emission_factor_units = 'kilograms_per_megajoule'
      
      # Assumptions:              half nat gas at 81.7% efficiency    half fuel oil at 84.6% efficiency      5% transmission losses
      district_heat.co2_emission_factor = (((natural_gas_energy_ef / 0.817) + (fuel_oil_energy_ef / 0.846)) / 2.0) / 0.95
      district_heat.co2_emission_factor_units = 'kilograms_per_megajoule'
      
      district_heat.save!
    end
    
    # FIXME TODO verify this stuff
  end
end
