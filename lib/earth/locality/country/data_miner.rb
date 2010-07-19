Country.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'iso_3166_code'
      string   'name'
    end
    
    import 'the official ISO country list',
           :url => 'http://www.iso.org/iso/list-en1-semic-3.txt',
           :skip => 2,
           :headers => false,
           :delimiter => ';',
           :encoding => 'ISO-8859-1' do
      key   'iso_3166_code', :field_number => 1
      store 'name', :field_number => 0
    end
  end
end

