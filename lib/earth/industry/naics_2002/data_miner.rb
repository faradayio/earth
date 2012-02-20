Naics2002.class_eval do
  data_miner do
    import "the U.S. Census 2002 NAICS code list",
           :url => 'http://www.census.gov/eos/www/naics/reference_files_tools/2002/naics_2_6_02.txt',
           :skip => 4,
           :headers => %w{ code description },
           :delimiter => '	' do
      key 'code'
      store 'description'
    end
  end
end
