GreenhouseGas.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'abbreviation'
      string  'ipcc_report'
      integer 'time_horizon'
      string  'time_horizon_units'
      integer 'global_warming_potential'
    end
    
    import "greenhouse gas global warming potentials taken from the IPCC AR4",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE1tUjBwS1ZHZnBUUG1XcVpkOTVHOVE&gid=0&output=csv' do
      key 'name'
      store 'abbreviation'
      store 'ipcc_report'
      store 'time_horizon', :units_field_name => 'time_horizon_units'
      store 'global_warming_potential'
    end
    
    verify "Abbreviation and IPCC report should never be missing" do
      GreenhouseGas.all.each do |record|
        %w{ abbreviation ipcc_report }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute} for GreenhouseGas '#{record.name}'"
          end
        end
      end
    end
    
    verify "Time horizon should be 100" do
      GreenhouseGas.all.each do |record|
        value = record.send(:time_horizon)
        unless value == 100
          raise "Invalid time horizon for GreenhouseGas '#{record.name}': #{value} (should be 100)"
        end
      end
    end
    
    verify "Time horizon units should be years" do
      GreenhouseGas.all.each do |record|
        units = record.send(:time_horizon_units)
        unless units == "years"
          raise "Invalid time horizon units for GreenhouseGas '#{record.name}': #{units} (should be years)"
        end
      end
    end
    
    verify "Global warming potential should be one or more" do
      GreenhouseGas.all.each do |record|
        value = record.send(:global_warming_potential)
        unless value >= 1
          raise "Invalid global warming potential for GreenhouseGas '#{record.name}': #{value} (should >= 1)"
        end
      end
    end
  end
end
