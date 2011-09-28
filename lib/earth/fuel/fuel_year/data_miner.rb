FuelYear.class_eval do
  data_miner do
    import "fuels with annually variable characteristics, derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdFZVSlZ3SUZsTzZLVTB5bVk5THdBN2c&gid=0&output=csv' do
      key 'name'
      store 'fuel_name'
      store 'year'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    process "Convert energy content of solid fuels to metric units" do
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 907.18474) # Google: 1_055.05585 MJ / 1 MMBtu * 1 short ton / 907.18474 kg
      connection.execute %{
        UPDATE fuel_years
        SET energy_content = 1.0 * energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_kilogram'
        WHERE energy_content_units = 'million_btu_per_short_ton'
      }
    end
    
    process "Convert energy content of liquid fuels to metric units" do
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 158.987295) # Google: 1_055.05585 MJ / 1 MMBtu * 1 barrel / 158.987295 l
      connection.execute %{
        UPDATE fuel_years
        SET energy_content = 1.0 * energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_litre'
        WHERE energy_content_units = 'million_btu_per_barrel'
      }
    end
    
    process "Convert energy content of gaseous fuels to metric units" do
      conversion_factor = (1.0 / 947.81712) * (35.3146667 / 1.0) # Google: 1.0 MJ / 947.81712 Btu * 35.3146667 cubic feet / 1 cubic m
      connection.execute %{
        UPDATE fuel_years
        SET energy_content = 1.0 * energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_cubic_metre'
        WHERE energy_content_units = 'btu_per_cubic_foot'
      }
    end
    
    process "Convert carbon content to metric units" do
      conversion_factor = (1_000_000_000_000.0 / 1.0) * (1.0 / 1_055_055_852_620.0) # Google: 1e12 g / Tg * 1 QBtu / 1.055e12 MJ
      connection.execute %{
        UPDATE fuel_years
        SET carbon_content = 1.0 * carbon_content * #{conversion_factor}, carbon_content_units = 'grams_per_megajoule'
        WHERE carbon_content_units = 'teragrams_per_quadrillion_btu'
      }
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1.0 / 1_000.0) * (44.0 / 12.0) # Google: 1 kg / 1e3 g * 44 CO2 / 12 C
      connection.execute %{
        UPDATE fuel_years
        SET co2_emission_factor = 1.0 * carbon_content * energy_content * oxidation_factor * (1 - biogenic_fraction) * #{conversion_factor},
            co2_biogenic_emission_factor = 1.0 * carbon_content * energy_content * oxidation_factor * biogenic_fraction * #{conversion_factor}
      }
    end
    
    process "Update emission factor units for solid fuels" do
      connection.execute %{
        UPDATE fuel_years
        SET co2_emission_factor_units = 'kilograms_per_kilogram',
            co2_biogenic_emission_factor_units = 'kilograms_per_kilogram'
        WHERE energy_content_units = 'megajoules_per_kilogram'
      }
    end
    
    process "Update emission factor units for liquid fuels" do
      connection.execute %{
        UPDATE fuel_years
        SET co2_emission_factor_units = 'kilograms_per_litre',
            co2_biogenic_emission_factor_units = 'kilograms_per_litre'
        WHERE energy_content_units = 'megajoules_per_litre'
      }
    end
    
    process "Update emission factor units for gaseous fuels" do
      connection.execute %{
        UPDATE fuel_years
        SET co2_emission_factor_units = 'kilograms_per_cubic_metre',
            co2_biogenic_emission_factor_units = 'kilograms_per_cubic_metre'
        WHERE energy_content_units = 'megajoules_per_cubic_metre'
      }
    end
  end
end
