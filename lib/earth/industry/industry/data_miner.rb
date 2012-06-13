Industry.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "the U.S. Census 2002 NAICS code list",
           :url => 'http://www.census.gov/eos/www/naics/reference_files_tools/2002/naics_2_6_02.txt',
           :skip => 4,
           :headers => false,
           :delimiter => '	' do
      key 'naics_code', :field_number => 0
      store 'description', :field_number => 1
    end
  end
end
