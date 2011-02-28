AutomobileTypeFuelYearControl.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      integer 'year'
      string  'control_name'
      string  'type_fuel_control_name'
      string  'type_fuel_year_name'
      float   'total_travel_percent'
    end
    
    import "automobile type fuel year control data derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGpQV2xMdlZkV1JzVlVTeU5ZalF6elE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'type_name'
      store 'fuel_common_name'
      store 'year'
      store 'control_name'
      store 'total_travel_percent'
    end
    
    process "Derive type fuel control name for association with AutomobileTypeFuelControl" do
      if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
        update_all "type_fuel_control_name = type_name || ' ' || fuel_common_name || ' ' || control_name"
      else
        update_all "type_fuel_control_name = CONCAT(type_name, ' ', fuel_common_name, ' ', control_name)"
      end
    end
    
    process "Derive type fuel year name for association with AutomobileTypeFuelYear" do
      if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
        update_all "type_fuel_year_name = type_name || ' ' || fuel_common_name || ' ' || year"
      else
        update_all "type_fuel_year_name = CONCAT(type_name, ' ', fuel_common_name, ' ', year)"
      end
    end
    
    %w{ type_name fuel_common_name control_name type_fuel_control_name type_fuel_year_name }.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        AutomobileTypeFuelYearControl.all.each do |record|
          value = record.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute.humanize.downcase} for AutomobileTypeFuelYearControl '#{record.name}'"
          end
        end
      end
    end
    
    verify "Year should be from 1990 to 2008" do
      AutomobileTypeFuelYearControl.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for AutomobileTypeFuelYearControl '#{record.name}': #{year} (should be from 1990 to 2008)"
        end
      end
    end
    
    # FIXME TODO verify "Total travel percent for each type fuel year should sum to one"
  end
end
