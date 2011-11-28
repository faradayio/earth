LodgingClass.class_eval do
  data_miner do
    import "a list of lodging classes",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFhwbmIzQzBwWW5uQV9KZDVPSDVRX3c&output=csv' do
      key 'name'
    end
  end
end
