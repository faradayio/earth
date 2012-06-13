EgridCountry.class_eval do
  data_miner do
    import "eGRID 2012 national-level data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2012V1_0_year09_DATA.xls',
           :sheet => 'GGL09',
           :skip => 4,
           :select => proc { |row| row['REGION'] == 'U.S.' } do
      key 'name',                   :field_name => 'REGION'
      store 'generation',           :field_name => 'GENERAT',  :units => :megawatt_hours
      store 'foreign_interchange',  :field_name => 'FRGNINTC', :units => :megawatt_hours
      store 'domestic_interchange', :field_name => 'INTRCHNG', :units => :megawatt_hours
      store 'consumption',          :field_name => 'CONSUMP',  :units => :megawatt_hours
    end
    
    process "Calculate loss factor" do
      update_all "loss_factor = (1.0 * generation + foreign_interchange + domestic_interchange - consumption) / generation"
    end
  end
end
