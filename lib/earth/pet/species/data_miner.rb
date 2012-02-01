Species.class_eval do
  data_miner do
    import "a list of pet species weights, dietary requirements, and diet emissions intensities",
           :url => 'http://static.brighterplanet.com/science/data/consumables/pets/species.csv' do
      key 'name', :field_name => 'species'
      store 'population'
      store 'weight', :from_units => :pounds, :to_units => :kilograms
      store 'marginal_dietary_requirement', :from_units => :kilocalories_per_pound, :to_units => :joules_per_kilogram
      store 'fixed_dietary_requirement', :from_units => :kilocalories, :to_units => :joules
      store 'diet_emission_intensity', :from_units => :grams_per_kilocalorie, :to_units => :kilograms_per_joule
      store 'minimum_weight', :from_units => :pounds, :to_units => :kilograms
      store 'maximum_weight', :from_units => :pounds, :to_units => :kilograms
    end
  end
end

