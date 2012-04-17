Sic1987.class_eval do
  data_miner do
    import "SIC 1987 codes derived from US Census SIC 1987 to NAICS 2002 concordance",
           :url => 'http://www.census.gov/eos/www/naics/concordances/1987_SIC_to_2002_NAICS.xls',
           :select => proc {|row| row['SIC'].to_i > 0} do
      key 'code', :synthesize => proc { |row| "%04d" % row['SIC'].to_i }
      store 'description', :synthesize => proc { |row| Sic1987.format_description row['SIC Title (and note)'] }
    end
  end
end
