FuelRegion.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'fuel_name'
      string 'region_name'
      float  'density'
      string 'density_units'
      string 'calorific_basis'
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
    
    process "Derive fuel region names for fuel with annually variable characteristics from FuelRegionYear" do
      FuelRegionYear.run_data_miner!
      INSERT_IGNORE %{INTO fuel_countries(name, fuel_name, region_name)
        SELECT DISTINCT fuel_region_years.fuel_region_name, fuel_region_years.fuel_name, fuel_region_years.region_name FROM fuel_region_years
      }
    end
    
    import "US fuels with non-anually-variable characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHdGQl9yT2IySUZYWW1TcmNLaWFTS3c&gid=0&output=csv' do
      key 'name'
      store 'fuel_name'
      store 'region_name'
      store 'calorific_basis'
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
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 158.987295) # Google: 1_055.05585 MJ / 1 MMBtu * 1 barrel / 158.987295 l
      connection.execute %{
        UPDATE fuel_countries
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_litre'
        WHERE energy_content_units = 'million_btu_per_barrel'
      }
    end
    
    process "Convert energy content of gaseous fuels to metric units" do
      conversion_factor = (1.0 / 947.81712) * (35.3146667 / 1.0) # Google: 1.0 MJ / 947.81712 Btu * 35.3146667 cubic feet / 1 cubic m
      connection.execute %{
        UPDATE fuel_countries
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_cubic_metre'
        WHERE energy_content_units = 'btu_per_cubic_foot'
      }
    end
    
    process "Convert carbon content to metric units" do
      conversion_factor = (1_000_000_000_000.0 / 1.0) * (1.0 / 1_055_055_852_620.0) # Google: 1e12 g / Tg * 1 QBtu / 1.055e12 MJ
      connection.execute %{
        UPDATE fuel_countries
        SET carbon_content = carbon_content * #{conversion_factor}, carbon_content_units = 'grams_per_megajoule'
        WHERE carbon_content_units = 'teragrams_per_quadrillion_btu'
      }
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1.0 / 1_000.0) * (44.0 / 12.0) # Google: 1 kg / 1e3 g * 44 CO2 / 12 C
      
      FuelRegion.where(FuelRegion.arel_table[:energy_content].not_eq(nil)).each do |record|
        record.co2_emission_factor = record.carbon_content * record.energy_content * record.oxidation_factor * (1 - record.biogenic_fraction) * conversion_factor
        record.co2_emission_factor_units = "kilograms_per_" + record.energy_content_units.split("_per_")[1]
        
        record.co2_biogenic_emission_factor = record.carbon_content * record.energy_content * record.oxidation_factor * record.biogenic_fraction * conversion_factor
        record.co2_biogenic_emission_factor_units = "kilograms_per_" + record.energy_content_units.split("_per_")[1]
        
        record.save
      end
    end
    
    # FIXME TODO verify this stuff
  end
end
