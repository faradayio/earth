ResidenceFuelPrice.class_eval do
  class FuelOilParser
    def initialize(options = {})
      # nothing
    end
    def apply(row)
      virtual_rows = []
      row.keys.grep(/(.*) Residual Fuel Oil/) do |location_column_name|
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
        if match_1.starts_with?('U.S.')
          locatable_id = 'US'
          locatable_type = 'Country'
        elsif match_1.include?('PADD')
          /\(PADD (.*)\)/.match match_1
          match_2 = $1
          next if match_2 == '1' # skip PADD 1 because we always prefer subdistricts
          locatable_id = match_2
          locatable_type = 'PetroleumAdministrationForDefenseDistrict'
        else
          locatable_id = match_1
          locatable_type = 'State'
        end
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price.to_f.cents.to(:dollars)
        new_row['year'] = date.year
        new_row['month'] = date.month
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
    end
  end

  class PropaneParser
    def initialize(options = {})
      # nothing
    end
    def apply(row)
      virtual_rows = []
      row.keys.grep(/(.*) Propane Residential Price/) do |location_column_name|
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
        if match_1.starts_with?('U.S.')
          locatable_id = 'US'
          locatable_type = 'Country'
        else
          /\(PADD (.*)\)/.match match_1
          match_2 = $1
          next if match_2 == '1' # skip PADD 1 because we always prefer subdistricts
          locatable_id = match_2
          locatable_type = 'PetroleumAdministrationForDefenseDistrict'
        end
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price.to_f.cents.to(:dollars)
        new_row['year'] = date.year
        new_row['month'] = date.month
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
    end
  end

  class NaturalGasParser
    def initialize(options = {})
      # nothing
    end
    def apply(row)
      virtual_rows = []
      row.keys.grep(/\A(.*) Natural Gas/) do |location_column_name|
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
        if match_1 == 'U.S.'
          locatable_id = 'US'
          locatable_type = 'Country'
        else
          locatable_id = match_1 # name
          locatable_type = 'State'
        end
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price
        new_row['year'] = date.year
        new_row['month'] = date.month
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
    end
  end

  data_miner do
    schema Earth.database_options do
      string  'row_hash'
      string 'residence_fuel_type_name'
      integer 'year'
      integer 'month'
      float   'price'
      string  'price_units'
      string  'price_description'
      string  'locatable_id'
      string  'locatable_type'
      index   ['price', 'residence_fuel_type_name', 'month', 'year', 'locatable_type', 'locatable_id']
      index   ['price', 'residence_fuel_type_name']
    end
    
    process "Define some unit conversions" do
      Conversions.register :dollars, :cents, 100
      Conversions.register :cubic_feet, :cubic_metres, 0.0283168466 # TODO conversions gem has 'cubic_metres'
    end

    # electricity in dollars per kWh
    import 'residential electricity prices from the EIA',
           :url => 'http://www.eia.doe.gov/cneaf/electricity/page/sales_revenue.xls',
           :select => lambda { |row| row['Year'].to_s.first(4).to_i > 1989 } do
      key 'row_hash'
      store 'residence_fuel_type_name', :static => 'electricity'
      store 'locatable_id', :field_name => 'State' # postal abbrev
      store 'locatable_type', :static => 'State'
      store 'price', :field_name => 'Average Retail Price Residential (c/kWh)', :from_units => :cents, :to_units => :dollars
      store 'price_description', :static => 'dollars_per_kilowatt_hour'
      store 'year', :field_name => 'Year'
      store 'month', :field_name => 'Month'
    end
    
    # natural gas in dollars per cubic metre
    # breaks if date-performance is enabled because DateTime.parse(...1899...) dies
    import 'residential natural gas prices from the EIA',
           :url => 'http://tonto.eia.doe.gov/dnav/ng/xls/ng_pri_sum_a_EPG0_FWA_DMcf_a.xls',
           :sheet => 'Data 1',
           :skip => 2,
           :select => lambda { |row| row['year'].to_i > 1989 },
           :transform => { :class => NaturalGasParser } do
      key 'row_hash'
      store 'residence_fuel_type_name', :static => 'natural gas'
      store 'locatable_id'
      store 'locatable_type'
      store 'price', :from_units => :cubic_metres, :to_units => :cubic_feet # denominator
      store 'price_description', :static => 'dollars_per_cubic_metre'
      store 'year'
      store 'month'
    end
    
    # dollars per litre
    # sabshere 4/18/2011 this file has gone missing
    import "residential fuel oil prices from the EIA",
           :url => 'http://tonto.eia.doe.gov/dnav/pet/xls/PET_PRI_RESID_A_EPPR_PTA_CPGAL_M.xls',
           :sheet => 'Data 1',
           :skip => 2,
           :select => lambda { |row| row['year'].to_i > 1989 },
           :transform => { :class => FuelOilParser } do
      key 'row_hash'
      store 'residence_fuel_type_name', :static => 'fuel oil'
      store 'locatable_id'
      store 'locatable_type'
      store 'price', :from_units => :litres, :to_units => :gallons # denominator
      store 'price_description', :static => 'dollars_per_litre'
      store 'year'
      store 'month'
    end
    
    # dollars per litre
    import "residential propane prices from the EIA",
           :url => 'http://tonto.eia.doe.gov/dnav/pet/xls/PET_PRI_PROP_A_EPLLPA_PRT_CPGAL_M.xls',
           :sheet => 'Data 1',
           :skip => 2,
           :select => lambda { |row| row['year'].to_i > 1989 },
           :transform => { :class => PropaneParser } do
      key 'row_hash'
      store 'residence_fuel_type_name', :static => 'propane'
      store 'locatable_id'
      store 'locatable_type'
      store 'price', :from_units => :litres, :to_units => :gallons # denominator
      store 'price_description', :static => 'dollars_per_litre'
      store 'year'
      store 'month'
    end
    
    # per Matt in https://brighterplanet.sifterapp.com/projects/30/issues/410/comments
    # "For coal and kerosene, there isn't good residential price data available, because hardly anybody actually uses them residentially."
  end
end

