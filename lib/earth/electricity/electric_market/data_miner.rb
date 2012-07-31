ElectricMarket.class_eval do
  data_miner do
    import 'IOU markets',
           :url => 'http://en.openei.org/datasets/files/899/pub/iou_zipcodes.csv',
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/electricity/electric_market/nrel_errata.csv" } do
      key 'id', :synthesize => proc { |row| row['compid'].to_i.to_s + '-' + row['zip'] }
      store 'zip_code_name', :field_name => 'zip'
      store 'electric_utility_eia_id', :field_name => 'compid'
    end
    
    import 'Non-IOU markets',
           :url => 'http://en.openei.org/datasets/files/899/pub/non-iou_zipcodes.csv',
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/electricity/electric_market/nrel_errata.csv" } do
      key 'id', :synthesize => proc { |row| row['compid'].to_i.to_s + '-' + row['zip'] }
      store 'zip_code_name', :field_name => 'zip'
      store 'electric_utility_eia_id', :field_name => 'compid'
    end
  end
end
