ServerType.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'data_center_company_name'
      float  'cpu'
      string 'cpu_units'
      float  'memory'
      string 'memory_units'
      float  'electricity_draw'
      string 'electricity_draw_units'
    end
    
    import "a list of server types and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdGExaW1ic2c0d2s1ZmpzeUdOa2kyRlE&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'data_center_company_name'
      store 'cpu',              :units_field_name => 'cpu_units'
      store 'memory',           :units_field_name => 'memory_units'
      store 'electricity_draw', :units_field_name => 'electricity_draw_units'
    end
    
    # FIXME TODO verify that data center company name appears in data_center_companies
    
    verify "Data center company name should never be missing" do
      ServerType.all.each do |server|
        if server.data_center_company_name.nil?
          raise "Invalid data center company name for ServerType #{server.name}: #{server.data_center_company_name}"
        end
      end
    end
    
    verify "Electricity draw should be more than zero" do
      ServerType.all.each do |server|
        unless server.electricity_draw > 0
          raise "Invalid electricity draw for ServerType #{server.name}: #{server.electricity_draw} (should be > 0)"
        end
      end
    end
    
    verify "Electricity draw units should be kilowatts" do
      ServerType.all.each do |server|
        unless server.electricity_draw_units == 'kilowatts'
          raise "Invalid electricity draw units for ServerType #{server.name}: #{server.electricity_draw_units} (should be kilowatts)"
        end
      end
    end
  end
end
