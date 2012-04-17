require 'earth/industry/naics_2002'
require 'earth/industry/sic_1987'

Naics2002Sic1987Concordance.class_eval do
  data_miner do
    import "the US Census SIC 1987 to NAICS 2002 concordance",
           :url => 'http://www.census.gov/eos/www/naics/concordances/1987_SIC_to_2002_NAICS.xls',
           :select => proc {|row| row['SIC'].to_i > 0 } do
      key 'row_hash'
      store 'naics_2002_code', :synthesize => proc { |row| "%06d" % row['2002 NAICS'].to_i }
      store 'sic_1987_code',   :synthesize => proc { |row| "%04d" % row['SIC'].to_i }
      store 'sic_note', :synthesize => proc { |row| Naics2002Sic1987Concordance.extract_note row['SIC Title (and note)'] }
    end
  end
end
