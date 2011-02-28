ComputationPlatform.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'data_center_company_name'
    end
    
    import "a list of computation platforms and the data center company they use",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdG5zVER5THhXRlE4N0RXTklVaS03Ymc&gid=0&gid=0&output=csv' do
      key   'name'
      store 'data_center_company_name'
    end
    
    verify "Data center company name should never be missing" do
      ComputationPlatform.all.each do |platform|
        unless platform.data_center_company_name.present?
          raise "Invalid data center company name for DataCenterCompany #{platform.name}: #{platform.data_center_company_name}"
        end
      end
    end
    
    # FIXME TODO verify that all data center company names appear in data_center_companies
  end
end
