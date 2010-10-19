AircraftType.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'aircraft_type_code'
      string 'description'
    end
    
    import "BTS's Aircraft Type Codes",
           :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE',
           :errata => Errata.new(:url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEZ2d3JQMzV5T1o1T3JmVlFyNUZxdEE&hl=en&single=true&gid=0&output=csv') do
      key 'aircraft_type_code', :field_name => 'Code'
      store 'description', :field_name => 'Description'
    end
  end
end
