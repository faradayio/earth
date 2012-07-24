LodgingClass.class_eval do
  data_miner do
    import "A Brighter Planet-curated list of lodging classes",
           :url => "file://#{Earth::DATA_DIR}/hospitality/lodging_classes.csv" do
      key :name
    end
  end
end
