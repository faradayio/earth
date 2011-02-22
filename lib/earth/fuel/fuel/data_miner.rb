Fuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'density'
      string 'density_units'
      float  'energy_content'
      string 'energy_content_units'
      float  'carbon_content'
      string 'carbon_content_units'
      float  'oxidation_factor'
      float  'biogenic_fraction'
      float  'co2_emission_factor'
      string 'co2_emission_factor_units'
      float  'co2_biogenic_emission_factor'
      string 'co2_biogenic_emission_factor_units'
    end
    
    process "Derive fuel names from FuelYear" do
      FuelYear.run_data_miner!
      INSERT_IGNORE %{INTO fuels(name)
        SELECT DISTINCT fuel_years.fuel_name FROM fuel_years
      }
    end
    
    import "fuels with non-variable characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGJmYkdtajZyV3Byb0lrd21xLVhXUGc&hl=en&output=csv' do
      key 'name'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    import "densities for aircraft fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHBjTVE4NmRlc05iUHVZR1E3eEJwOGc&hl=en&output=csv' do
      key 'name'
      store 'density', :units_field_name => 'density_units'
    end
    
    process "Convert energy content of liquid fuels to metric units" do
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 158.987295) # Google: 1_055.05585 MJ / 1 MMBtu * 1 barrel / 158.987295 l
      connection.execute %{
        UPDATE fuels
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_litre'
        WHERE energy_content_units = 'million_btu_per_barrel'
      }
    end
    
    process "Convert energy content of gaseous fuels to metric units" do
      conversion_factor = (1.0 / 947.81712) * (35.3146667 / 1.0) # Google: 1.0 MJ / 947.81712 Btu * 35.3146667 cubic feet / 1 cubic m
      connection.execute %{
        UPDATE fuels
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_cubic_metre'
        WHERE energy_content_units = 'btu_per_cubic_foot'
      }
    end
    
    process "Convert carbon content to metric units" do
      conversion_factor = (1_000_000_000_000.0 / 1.0) * (1.0 / 1_055_055_852_620.0) # Google: 1e12 g / Tg * 1 QBtu / 1.055e12 MJ
      connection.execute %{
        UPDATE fuels
        SET carbon_content = carbon_content * #{conversion_factor}, carbon_content_units = 'grams_per_megajoule'
        WHERE carbon_content_units = 'teragrams_per_quadrillion_btu'
      }
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1.0 / 1_000.0) * (44.0 / 12.0) # Google: 1 kg / 1e3 g * 44 CO2 / 12 C
      connection.execute %{
        UPDATE fuels
        SET co2_emission_factor = carbon_content * energy_content * oxidation_factor * (1 - biogenic_fraction) * #{conversion_factor},
            co2_biogenic_emission_factor = carbon_content * energy_content * oxidation_factor * biogenic_fraction * #{conversion_factor}
      }
    end
    
    process "Update emission factor units for liquid fuels" do
      connection.execute %{
        UPDATE fuels
        SET co2_emission_factor_units = 'kilograms_per_litre',
            co2_biogenic_emission_factor_units = 'kilograms_per_litre'
        WHERE energy_content_units = 'megajoules_per_litre'
      }
    end
    
    process "Update emission factor units for gaseous fuels" do
      connection.execute %{
        UPDATE fuels
        SET co2_emission_factor_units = 'kilograms_per_cubic_metre',
            co2_biogenic_emission_factor_units = 'kilograms_per_cubic_metre'
        WHERE energy_content_units = 'megajoules_per_cubic_metre'
      }
    end
    
    # FIXME TODO verify this stuff
  end
end
