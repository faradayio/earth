EgridRegion.class_eval do
  data_miner do
    import "eGRID 2010 regions and loss factors",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2010V1_1_STIE_USGC.xls',
           :sheet => 'STIE07',
           :skip => 4,
           :select => lambda { |row| row['eGRID2010 year 2007 file state sequence number'].to_i.between?(1, 51) } do
      key   'name', :field_name => 'Grid region (E=Eastern grid, W=Western grid, AK=Alaska, HI=Hawaii, TX=Texas)'
      store 'loss_factor', :field_name => 'Year 2007 grid gross loss factor'
    end
    
    # Need this for fallback loss_factor calculation
    process "Ensure EgridCountry is populated" do
      EgridCountry.run_data_miner!
    end
    
    # DEPRECATED but don't remove until confirmed that all emitters use EgridRegion.fallback rather than EgridRegion.find_by_abbreviation 'US'
    process "Calculate national averages" do
      us_average = find_or_create_by_name 'US'
      us_average.loss_factor = (EgridCountry.us.generation + EgridCountry.us.imports - EgridCountry.us.consumption) / EgridCountry.us.generation
      us_average.save!
    end
  end
end
