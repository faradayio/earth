Industry.class_eval do
  data_miner do
    import "the U.S. Census 2002 NAICS code list",
           :url => 'http://www.census.gov/epcd/naics02/naicod02.txt',
           :skip => 4,
           :headers => false,
           :delimiter => '	' do
      key 'naics_code', :field_number => 0
      store 'description', :field_number => 1
    end
  end
end
