GreenButtonAdoption.class_eval do
  data_miner do
    import 'Green Button implementers',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.implemented',
           :headers => %w{electric_utility_name} do
      key 'electric_utility_name'
      store 'implemented', :static => true
    end

    import 'Green Button committers',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.committed',
           :headers => %w{electric_utility_name} do
      key 'electric_utility_name'
      store 'committed', :static => true
    end
  end
end
