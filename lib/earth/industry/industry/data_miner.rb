require 'earth/locality/data_miner'
Industry.class_eval do
  def self.sic_lookup(naics_code)
    @sic_lookup ||= RemoteTable.new(:url => 'http://www.census.gov/epcd/naics02/NAICS02toSIC87.xls')
    record = @sic_lookup.find { |lookup| lookup['NAICS 2002'].to_i.to_s == naics_code }
    record ? record['SIC'].to_i.to_s : nil
  end

  data_miner do
    import "the U.S. Census 2002 NAICS code list",
           :url => 'http://www.census.gov/epcd/naics02/naicod02.txt',
           :skip => 4,
           :headers => false,
           :delimiter => '	' do
      key 'naics_code', :field_number => 0
      store 'sic', :synthesize => Proc.new { |row| Industry.sic_lookup(row[0]) }
      store 'description', :field_number => 1
    end
  end
end
