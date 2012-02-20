Naics2007.class_eval do
  data_miner do
    import "the U.S. Census 2007 NAICS code list",
           :url => 'http://www.census.gov/eos/www/naics/reference_files_tools/2007/naics07.txt',
           :skip => 2,
           :headers => %w{ IGNORE code description },
           :delimiter => '	' do
      key 'code'
      store 'description'
    end
  end
end
