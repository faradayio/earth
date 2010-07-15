EgridRegion.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string   'name'
      float    'loss_factor'
    end
    
    import "eGRID regions and loss factors derived from eGRID 2007 data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
           :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year0504_STIE_USGC.xls',
           :sheet => 'STIE05',
           :select => lambda { |row| row['eGRID2007 2005 file State sequence number'].to_i.between?(1, 51) },
           :skip => 4 do
      key   'name', :field_name => 'Grid region (E=Eastern grid, W=Western grid, AK=Alaska, HI=Hawaii, TX=Texas)'
      store 'loss_factor', :field_name => '2005 grid gross loss factor'
    end
  end
end

