require 'earth/locality/data_miner'
ComputationCarrierRegion.class_eval do
  data_miner do
    import "a list of computation carrier regions",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdGFEU1gtVzFPeS0tV1VnR05WZ2ZFUVE&gid=0&output=csv' do
      key   'name'
      store 'computation_carrier_name'
      store 'region'
      store 'egrid_subregion_abbreviation'
    end
    
    # FIXME TODO verify carrier_name appears in Carrier
    # FIXME TODO verify egrid_subregion_abbreviation appears in EgridSubregion
  end
end
