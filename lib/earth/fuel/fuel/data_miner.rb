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
    
    import "liquid fuels with non-variable characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGJmYkdtajZyV3Byb0lrd21xLVhXUGc&output=csv',
           :select => proc {|row| row['energy_content_units'] == 'million_btu_per_barrel'} do
      key 'name'
      store 'physical_units', :static => 'litre'
      store 'energy_content', :from_units => :million_btu_per_barrel,        :to_units => :megajoules_per_litre
      store 'carbon_content', :from_units => :teragrams_per_quadrillion_btu, :to_units => :grams_per_megajoule
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    import "gaseous fuels with non-variable characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGJmYkdtajZyV3Byb0lrd21xLVhXUGc&output=csv',
           :select => proc {|row| row['energy_content_units'] == 'btu_per_cubic_foot'} do
      key 'name'
      store 'physical_units', :static => 'cubic_metre'
      store 'energy_content', :from_units => :btus_per_cubic_foot,           :to_units => :megajoules_per_cubic_metre
      store 'carbon_content', :from_units => :teragrams_per_quadrillion_btu, :to_units => :grams_per_megajoule
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    import "hydrogen",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGJmYkdtajZyV3Byb0lrd21xLVhXUGc&output=csv',
           :select => proc {|row| row['energy_content_units'] == 'megajoules_per_kilogram'} do
      key 'name'
      store 'physical_units', :static => 'kilogram'
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
    
    process "Create district heat" do
      natural_gas = find_by_name 'Pipeline Natural Gas'
      fuel_oil = find_by_name 'Distillate Fuel Oil No. 2'
      district_heat = find_or_create_by_name "District Heat"
      
      # Assumptions:              half nat gas at 81.7% efficiency    half fuel oil at 84.6% efficiency      5% transmission losses
      district_heat.carbon_content = (((natural_gas.carbon_content / 0.817) + (fuel_oil.carbon_content / 0.846)) / 2.0) / 0.95
      district_heat.carbon_content_units = 'grams_per_megajoule'
      district_heat.energy_content = 1.0
      district_heat.energy_content_units = 'megajoules_per_megajoule'
      district_heat.oxidation_factor = 1.0
      district_heat.biogenic_fraction = 0.0
      district_heat.physical_units = 'megajoule'
      district_heat.save!
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      where('carbon_content IS NOT NULL and energy_content IS NOT NULL and oxidation_factor IS NOT NULL and biogenic_fraction IS NOT NULL').update_all(%{
        co2_emission_factor                = 1.0 * carbon_content * #{1.grams.to(:kilograms).carbon.to(:co2)} * energy_content * oxidation_factor * (1.0 - biogenic_fraction),
        co2_emission_factor_units          = 'kilograms_per_' || physical_units,
        co2_biogenic_emission_factor       = 1.0 * carbon_content * #{1.grams.to(:kilograms).carbon.to(:co2)} * energy_content * oxidation_factor * biogenic_fraction,
        co2_biogenic_emission_factor_units = 'kilograms_per_' || physical_units
      })
    end
  end
end
