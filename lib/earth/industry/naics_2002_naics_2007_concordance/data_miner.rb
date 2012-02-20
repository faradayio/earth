require 'earth/industry/naics_2002'
require 'earth/industry/naics_2007'

Naics2002Naics2007Concordance.class_eval do
  data_miner do
    import "the US Census NAICS 2002 to NAICS 2007 concordance",
           :url => 'http://www.census.gov/eos/www/naics/concordances/2002_to_2007_NAICS.xls',
           :skip => 3,
           :headers => %w{ 2002_code 2002_title 2007_code 2007_title } do
      key 'row_hash'
      store 'naics_2002_code', :synthesize => lambda { |row| "%06d" % row['2002_code'].to_i }
      store 'naics_2007_code', :synthesize => lambda { |row| "%06d" % row['2007_code'].to_i }
      store 'naics_2002_note', :synthesize => lambda { |row| extract_note row['2002_title'] }
    end
  end
end
