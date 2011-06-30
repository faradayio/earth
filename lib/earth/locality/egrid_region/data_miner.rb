EgridRegion.class_eval do
  data_miner do
    import "eGRID regions and loss factors derived from eGRID 2007 data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
           :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year0504_STIE_USGC.xls',
           :sheet => 'STIE05',
           :skip => 4,
           :select => lambda { |row| row['eGRID2007 2005 file State sequence number'].to_i.between?(1, 51) } do
      key   'name', :field_name => 'Grid region (E=Eastern grid, W=Western grid, AK=Alaska, HI=Hawaii, TX=Texas)'
      store 'loss_factor', :field_name => '2005 grid gross loss factor'
    end
    
    # resurrected from a7bb363f10d951957dd051ff3cfb81c280f61151
    import "the US average grid loss factor derived eGRID 2007 data",
           # :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
           :url => 'file:///Users/seamus/egrid/eGRID2007_Version1-1.zip',
           :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year0504_STIE_USGC.xls',
           :sheet => 'USGC',
           :skip => 5 do
      key 'name', :static => 'US'
      store 'loss_factor', :synthesize => lambda { |row| (row['USTNGN05'].to_f + row['USTNFI05'].to_f - row['USTCON05'].to_f) / row['USTNGN05'].to_f }
    end

    verify "Loss factor should be greater than zero and less than one" do
      EgridRegion.all.each do |region|
        unless region.loss_factor > 0 and region.loss_factor < 1
          raise "Invalid loss factor for EgridRegion #{region.name}: #{region.loss_factor} (should be > 0 and < 1)"
        end
      end
    end
    
    # FIXME TODO verify fallback loss factor
  end
end
