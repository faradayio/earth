IndustriesProductLines.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'row_hash'
      string 'naics_code'
      float  'ratio'
      string 'ps_code'
      float  'revenue_allocated'
    end
    
    import "a list of the products and services sold by establishments in the wholesale and retail trade industries",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEtua2FjdThDRzFTWGhOOFZLUkVaeVE&hl=en&single=true&gid=0&output=csv' do
      key 'row_hash'
      store 'naics_code'
      store 'ratio'
      store 'ps_code'
      store 'revenue_allocated'
    end
  end
end
