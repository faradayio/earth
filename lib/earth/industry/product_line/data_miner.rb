ProductLine.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'ps_code'
      string 'description'
      string 'broadline' # FIXME TODO do we need this?
      string 'parent'    # FIXME TODO do we need this?
    end
    
    import "the U.S. Census list of Products and Services codes for the wholesale and retail trade sectors",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGxOUzBId0VuWTB0U0dOUHExOVlWTlE&hl=en&single=true&gid=0&output=csv' do
      key 'ps_code'
      store 'description'
      store 'broadline'
      store 'parent'
    end
  end
end
