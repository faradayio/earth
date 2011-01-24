Country.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'iso_3166_code'
      string 'name'
      float  'flight_route_inefficiency_factor'
    end
    
    import 'the official ISO country list',
           :url => 'http://www.iso.org/iso/list-en1-semic-3.txt',
           :skip => 2,
           :headers => false,
           :delimiter => ';',
           :encoding => 'ISO-8859-1' do
      key   'iso_3166_code', :field_number => 1
      store 'name', :field_number => 0
    end
    
    import "country-specific flight route inefficiency factors derived from Kettunen et al. (2005)",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG0yc3BxYUkybWV5M3RKb2t4X0JUOFE&hl=en&single=true&gid=0&output=csv' do
      key   'iso_3166_code'
      store 'flight_route_inefficiency_factor'
    end
  end
end
