Fuel.class_eval do
  class IpccFuelParser
    VIRTUAL_NAMES = {
      'Jet Kerosene' =>              'Jet Fuel',
      'Other Kerosene' =>            'Kerosene',
      'Gas/Diesel Oil' =>            ['Distillate Fuel Oil No. 1', 'Distillate Fuel Oil No. 2', 'Distillate Fuel Oil No. 4'],
      'Residual Fuel Oil' =>         ['Residual Fuel Oil No. 5', 'Residual Fuel Oil No. 6'],
      'Liquefied Petroleum Gases' => 'LPG (energy use)',
      'Biogasoline' =>               'Ethanol',
      'Biodiesels' =>                'Biodiesel'
    }
    def initialize(*)
    end
    
    def apply(row)
      if virtual_names = VIRTUAL_NAMES[row['name']]
        Array.wrap(virtual_names).map { |virtual_name| row.merge('name' => virtual_name) }
      else
        row
      end
    end
  end
  
  data_miner do
    schema Earth.database_options do
      string 'name'
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
    
    import "global fuel data derived from the IPCC Guidelines for National Greenhouse Gas Inventories",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdFk5dzJvT2ozNjdEU05pWVJUTUpTOXc&gid=0&output=csv',
           :transform => { :class => IpccFuelParser } do
      key 'name'
      store 'calorific_basis'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1_000.0 / 1.0) * (1.0 / 1_000_000.0) * (44.0 / 12.0) # Google: 1000 Gg / 1 Tg * 1 Gg / 1_000_000 kg * 44 CO2 / 12 C
      connection.execute %{
        UPDATE fuels
        SET co2_emission_factor = carbon_content * energy_content * oxidation_factor * (1 - biogenic_fraction) * #{conversion_factor},
            co2_biogenic_emission_factor = carbon_content * energy_content * oxidation_factor * biogenic_fraction * #{conversion_factor},
            co2_emission_factor_units = 'kilograms_per_kilogram',
            co2_biogenic_emission_factor_units = 'kilograms_per_kilogram'
      }
    end
    
    # FIXME TODO verify this stuff
  end
end
