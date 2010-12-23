EgridSubregion.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'abbreviation'
      string 'name'
      float  'electricity_emission_factor'
      string 'electricity_emission_factor_units'
      string 'nerc_abbreviation'
      string 'egrid_region_name'
    end
    
    # process "define some unit conversions" do
    #   Conversions.register :pounds_per_megawatt_hour, :kilograms_per_kilowatt_hour, 0.00045359237
    #   Conversions.register :pounds_per_gigawatt_hour, :kilograms_per_kilowatt_hour, 0.00000045359237
    # end
    # 
    # NOTE: the following import uses an 18 Mb zip - don't know if two imports will cause it to be downloaded twice...
    # 
    # import "eGRID regions and electricity emission factors derived from eGRID 2007 data",
    #        :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
    #        :filename => 'eGRID2007V1_1_year05_aggregation.xls',
    #        :sheet => 'SRL05',
    #        :skip => 3,
    #        :select => lambda { |row| row['eGRID2007 2005 file eGRID subregion location (operator)-based sequence number'].to_i.between?(1, 26) } do
    #   key   'abbreviation', :field_name => 'eGRID subregion acronym'
    #   store 'name', :field_name => 'eGRID subregion name associated with eGRID subregion acronym'
    #   store 'nerc_abbreviation', :field_name => 'NERC region acronym associated with the eGRID subregion acronym'
    #   store 'electricity_ef_co2', :field_name => 'eGRID subregion annual CO2 output emission rate (lb/MWh)', :from_units => :pounds_per_megawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    #   store 'electricity_ef_ch4', :field_name => 'eGRID subregion annual CH4 output emission rate (lb/GWh)', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    #   store 'electricity_ef_n2o', :field_name => 'eGRID subregion annual N2O output emission rate (lb/GWh)', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    # end
    # 
    # import "US average electricity emission factors derived from eGRID 2007 data",
    #        :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
    #        :filename => 'eGRID2007V1_1_year05_aggregation.xls',
    #        :sheet => 'US05',
    #        :skip => 3,
    #        :select => lambda { |row| row['eGRID2007 2005 file US sequence number'].to_i.is?(1) } do
    #   key   # the single row should be keyed 'US'
    #   store 'name' # the single row should be named 'United States Average'
    #   store 'electricity_ef_co2', :field_name => 'US annual CO2 output emission rate (lb/MWh)', :from_units => :pounds_per_megawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    #   store 'electricity_ef_ch4', :field_name => 'US annual CH4 output emission rate (lb/GWh)', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    #   store 'electricity_ef_n2o', :field_name => 'US annual N2O output emission rate (lb/GWh)', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    # end
    # 
    # import "the eGRID regions associated with each subregion" do
    #        :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRORTJNSWRMQ1puRVprYlAtZHhDaFE&hl=en&single=true&gid=0&output=csv' do
    #   key 'abbreviation'
    #   store 'egrid_region_name'
    # end
    # 
    # process "Calculate CO2e emission factor"
    #   # multiply each gas ef by the gas GWP and sum
    # end
    
    import "a list of eGRID subregions and emissions factors derived from eGRID 2007 data",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRORTJNSWRMQ1puRVprYlAtZHhDaFE&hl=en&single=true&gid=0&output=csv' do
      key   'abbreviation'
      store 'name'
      store 'nerc_abbreviation'
      store 'egrid_region_name'
      store 'electricity_emission_factor', :units_field_name => 'electricity_emission_factor_units'
    end
    
    # FIXME TODO make this work
    # verify "eGRID region name should appear in egrid_regions" do
    #   regions = EgridRegion.all.map { |region| region.name }
    #   EgridSubregion.all.each do |subregion|
    #     unless regions.includes? subregion.egrid_region_name
    #       raise "Invalid eGRID region name for EgridSubregion #{subregion.name}: #{subregion.egrid_region_name} (not found in egrid_regions)"
    #     end
    #   end
    # end
    
    verify "Electricity emission factor should be greater than zero" do
      EgridSubregion.all.each do |subregion|
        unless subregion.electricity_emission_factor > 0
          raise "Invalid electricity emission factor for EgridSubregion #{subregion.name}: #{subregion.electricity_emission_factor} (should be > 0)"
        end
      end
    end
    
    verify "Electricity emission factor units should be kilograms per kilowatt hour" do
      EgridSubregion.all.each do |subregion|
        unless subregion.electricity_emission_factor_units == "kilograms_per_kilowatt_hour"
          raise "Invalid electricity emission factor units for EgridSubregion #{subregion.name}: #{subregion.electricity_emission_factor_units} (should be kilograms_per_kilowatt_hour)"
        end
      end
    end
  end
end
