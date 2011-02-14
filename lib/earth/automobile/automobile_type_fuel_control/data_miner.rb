AutomobileTypeFuelControl.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      string  'control_name'
      float   'ch4_emission_factor'
      string  'ch4_emission_factor_units'
      float   'n2o_emission_factor'
      string  'n2o_emission_factor_units'
    end
    
    import "automobile type fuel control data derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEloSTU5YUNOUXRFRUcxWHlTUi1GMkE&hl=en&output=csv' do
      key   'name'
      store 'type_name'
      store 'fuel_common_name'
      store 'control_name'
      store 'ch4_emission_factor', :units_field_name => 'ch4_emission_factor_units'
      store 'n2o_emission_factor', :units_field_name => 'n2o_emission_factor_units'
    end
    
    verify "Type name, fuel common name, and control name should never be missing" do
      AutomobileTypeFuelControl.all.each do |record|
        %w{ type_name fuel_common_name control_name }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute} for AutomobileTypeFuelControl '#{record.name}'"
          end
        end
      end
    end
    
    verify "Emission factors should be greater than zero" do
      AutomobileTypeFuelControl.all.each do |record|
        %w{ ch4_emission_factor n2o_emission_factor }.each do |factor|
          value = record.send(:"#{factor}")
          unless value > 0
            raise "Invalid #{factor} for AutomobileTypeFuelControl '#{record.name}': #{valuel} (should be > 0)"
          end
        end
      end
    end
    
    verify "Emission factor units should be kilograms per kilometre" do
      AutomobileTypeFuelControl.all.each do |record|
        %w{ ch4_emission_factor_units n2o_emission_factor_units }.each do |attribute|
          units = record.send(:"#{attribute}")
          unless units == "kilograms_per_kilometre"
            raise "Invalid #{attribute} for AutomobileTypeFuelControl '#{record.name}': #{units} (should be kilograms_per_kilometre)"
          end
        end
      end
    end
  end
end
