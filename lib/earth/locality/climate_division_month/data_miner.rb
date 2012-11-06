ClimateDivisionMonth.class_eval do
  # Derived from state code table in ftp://ftp.ncdc.noaa.gov/pub/data/cirs/divisional.README
  STATE_CODES = {
     1 => 'AL',
     2 => 'AZ',
     3 => 'AR',
     4 => 'CA',
     5 => 'CO',
     6 => 'CT',
     7 => 'DE',
     8 => 'FL',
     9 => 'GA',
    10 => 'ID',
    11 => 'IL',
    12 => 'IN',
    13 => 'IA',
    14 => 'KS',
    15 => 'KY',
    16 => 'LA',
    17 => 'ME',
    18 => 'MD',
    19 => 'MA',
    20 => 'MI',
    21 => 'MN',
    22 => 'MS',
    23 => 'MO',
    24 => 'MT',
    25 => 'NE',
    26 => 'NV',
    27 => 'NH',
    28 => 'NJ',
    29 => 'NM',
    30 => 'NY',
    31 => 'NC',
    32 => 'ND',
    33 => 'OH',
    34 => 'OK',
    35 => 'OR',
    36 => 'PA',
    37 => 'RI',
    38 => 'SC',
    39 => 'SD',
    40 => 'TN',
    41 => 'TX',
    42 => 'UT',
    43 => 'VT',
    44 => 'VA',
    45 => 'WA',
    46 => 'WV',
    47 => 'WI',
    48 => 'WY'
  }

  MONTH_CODES = {
    'jan' => 1,
    'feb' => 2,
    'mar' => 3,
    'apr' => 4,
    'may' => 5,
    'jun' => 6,
    'jul' => 7,
    'aug' => 8,
    'sep' => 9,
    'oct' => 10,
    'nov' => 11,
    'dec' => 12
  }

  ::FixedWidth.define :noaa_degree_day_data do |d|
    d.rows do |row|
      row.trap { true } # there's only one section
      row.column 'state_code',      2, :type => :integer
      row.column 'division_number', 2, :type => :integer
      row.column 'element_code',    2, :type => :integer
      row.column 'year',            4, :type => :integer
      row.column 'jan',             7, :type => :float # value for jan
      row.column 'feb',             7, :type => :float # value for feb
      row.column 'mar',             7, :type => :float # value for mar
      row.column 'apr',             7, :type => :float # value for apr
      row.column 'may',             7, :type => :float # value for may
      row.column 'jun',             7, :type => :float # value for jun
      row.column 'jul',             7, :type => :float # value for jul
      row.column 'aug',             7, :type => :float # value for aug
      row.column 'sep',             7, :type => :float # value for sep
      row.column 'oct',             7, :type => :float # value for oct
      row.column 'nov',             7, :type => :float # value for nov
      row.column 'dec',             7, :type => :float # value for dec
    end
  end

  class NoaaDegreeDayParser
    def initialize(options = {})
      # nothing
    end
    
    def apply(row)
      virtual_rows = []
      if row['year'].to_i > 2010
        %w{ jan feb mar apr may jun jul aug sep oct nov dec }.each do |month|
          if row[month].to_i >= 0
            new_row = ActiveSupport::OrderedHash.new
            new_row['climate_division_name'] = STATE_CODES[row['state_code'].to_i] + row['division_number'].to_i.to_s
            new_row['year'] = row['year']
            new_row['month'] = MONTH_CODES[month]
            new_row['name'] = new_row['climate_division_name'] + '-' + new_row['year'] + '-' + new_row['month'].to_s
            new_row['degree_days'] = row[month]
            virtual_rows << new_row
          end
        end
      end
      virtual_rows
    end
  end

  data_miner do
    import "recent NOAA NCDC climate division heating degree day data",
           :url => 'ftp://ftp.ncdc.noaa.gov/pub/data/cirs/drd964x.hdd.txt',
           :format => :fixed_width,
           :schema_name => :noaa_degree_day_data,
           :transform => { :class => NoaaDegreeDayParser } do
      key 'name'
      store 'climate_division_name'
      store 'year'
      store 'month'
      store 'heating_degree_days', :field_name => 'degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
    end
      
    import "recent NOAA NCDC climate division cooling degree day data",
           :url => 'ftp://ftp.ncdc.noaa.gov/pub/data/cirs/drd964x.cdd.txt',
           :format => :fixed_width,
           :schema_name => :noaa_degree_day_data,
           :transform => { :class => NoaaDegreeDayParser } do
      key 'name'
      store 'climate_division_name'
      store 'year'
      store 'month'
      store 'cooling_degree_days', :field_name => 'degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
    end
  end
end
