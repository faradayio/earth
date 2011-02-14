AutomobileTypeFuelYearControl.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      integer 'year'
      string  'control_name'
      float   'total_travel_percent'
    end
    
    import "automobile type fuel year control data derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGpQV2xMdlZkV1JzVlVTeU5ZalF6elE&hl=en&output=csv' do
      key   'name'
      store 'type_name'
      store 'fuel_common_name'
      store 'year'
      store 'control_name'
      store 'total_travel_percent'
    end
    
    verify "Type name, fuel common name, and control name should never be missing" do
      AutomobileTypeFuelYearControl.all.each do |record|
        %w{ type_name fuel_common_name control_name }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute} for AutomobileTypeFuelYearControl '#{record.name}'"
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
    
    # FIXME TODO
    # verify "Total travel percent for each type fuel year should sum to one" do
    # end
  end
end
