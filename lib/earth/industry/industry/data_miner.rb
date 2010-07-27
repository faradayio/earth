Industry.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string 'naics_code'
      string 'description'
    end
    
    # FIXME TODO some codes need to be disaggregated:
    # 31-33 "manufacturing" should be 31, 32, 33 all "manufacturing"
    # 44-45 "retail trade" should be 44 and 45 "retail trade"
    # 48-49 "transportation and warehouseing" should be 48 and 49 "transportation and warehousing"
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
