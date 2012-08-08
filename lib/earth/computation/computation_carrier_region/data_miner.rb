ComputationCarrierRegion.class_eval do
  data_miner do
    import "a list of computation carrier regions",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdGFEU1gtVzFPeS0tV1VnR05WZ2ZFUVE&gid=0&output=csv' do
      key   'name'
      store 'computation_carrier_name'
      store 'region'
      store 'egrid_subregion_abbreviation'
    end
  end
end
