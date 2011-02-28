ServerTypeAlias.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'server_type_name'
      string 'platform_name'
    end
    
    import "a list of server type aliases and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdDdkVlBzSUYweFN0OHBreEN6YTdTZ3c&hl=en&gid=0&output=csv' do
      key   'name', :field_name => 'alias'
      store 'server_type_name'
      store 'platform_name'
    end
    
    # FIXME TODO verify that server type name appears in server_types
    # FIXME TODO verify that platform name appears in computation_platforms
    
    verify "Server type name and platform name should never be missing" do
      ServerTypeAlias.all.each do |server_alias|
        [:server_type_name, :platform_name].each do |x|
          test_item = server_alias.send(x)
          unless test_item.present?
            raise "Invalid #{x} for ServerTypeAlias #{server_alias.name}: #{test_item}"
          end
        end
      end
    end
  end
end
