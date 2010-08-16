FuelPrice.class_eval do
  # FIXME TODO phase 2
  # location
  # month/year

  class RetailGasolineParser
    def initialize(options = {})
      # nothing
    end
    def add_hints!(bus)
      # FIXME TODO this needs to run for sheets 'Data 1' 'Data 2' and 'Data 3'
      bus[:sheet] = 'Data 1'
      bus[:skip] = 2
      bus[:select] = lambda { |row| row['year'].to_i > 1989 }
    end
    def apply(row)
      #FIXME TODO for 'Data 1'
      virtual_rows = []
      row.keys.grep(/Weekly (.*) All Grades All Formulations Retail Gasoline/) do |location_column_name|
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
        locatable_id = 'US'
        locatable_type = 'Country'
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price
        new_row['year'] = date.year
        new_row['month'] = date.month
        new_row['week'] = date.week
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
      
      # FIXME TODO for 'Data 2'
      virtual_rows = []
      row.keys.grep(/Weekly (.*) All Grades All Formulations Retail Gasoline/) do |location_column_name|
        # FIXME TODO somehow skip the location_column_name ('weekly east coast...')
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
        if match_1.include?('PADD')
          /\(PADD (.*)\)/.match match_1
          match_2 = $1
          next if match_2 == '5' # skip this because it's actually PADD 5 except california
          locatable_id = match_2
          locatable_type = 'PetroleumAdministrationForDefenseDistrict'
        else
          locatable_id = PetroleumAdministrationForDefenseDistrict.find_by_district_name(match_1).district_code
          locatable_type = 'State'
        end        
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price
        new_row['year'] = date.year
        new_row['month'] = date.month
        new_row['week'] = date.week
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
      
      # FIXME TODO for 'Data 2'
      virtual_rows = []
      row.keys.grep(/Weekly (.*) All Grades All Formulations Retail Gasoline/) do |location_column_name|
        match_1 = $1
        next if (price = row[location_column_name]).blank? or (date = row['Date']).blank?
          locatable_id = match_1
          locatable_type = 'State'
        end
        date = Time.parse(date)
        new_row = ActiveSupport::OrderedHash.new
        new_row['locatable_id'] = locatable_id
        new_row['locatable_type'] = locatable_type
        new_row['price'] = price
        new_row['year'] = date.year
        new_row['month'] = date.month
        new_row['week'] = date.week
        row_hash = RemoteTable::Transform.row_hash new_row
        new_row['row_hash'] = row_hash
        virtual_rows << new_row
      end
      virtual_rows
    end
  end


  data_miner do
    schema :options => Earth.database_options do
      string  'name'
      float   'price'
      string  'price_units'
    end
    
    import 'fuel prices derived from the EIA',
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHlSdXJoOFB5aEpHenJQbTVJdS1pMVE',
           :select => lambda { |row| row['fuel_type_name'].present? } do
      key   'name', :field_name => 'fuel_type_name'
      store 'price', :units_field_name => 'price_units'
    end
    
    import 'retail gasoline prices from the EIA',
           :url => 'http://www.eia.gov/dnav/pet/xls/PET_PRI_GND_A_EPM0_PTE_CPGAL_W.xls',
           :transform => { :class => RetailGasolineParser, } do
      key   'row_hash'
      store 'fuel_type_name'
      store 'locatable_id'
      store 'locatable_type'
      store 'price', :from_units => :cents_per_gallon, :to_units => :dollars_per_litre
      store 'year'
      store 'month'
      store 'week'
  end
end
