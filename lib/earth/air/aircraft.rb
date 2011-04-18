class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  # Find every aircraft whose name is similar to search_name
  def self.similar(search_name)
    @ltd ||= LooseTightDictionary.new(all, :haystack_reader => lambda { |record| record.descriptive_name })
    @ltd.find_all search_name
  end
  
  belongs_to :aircraft_class,    :foreign_key => 'class_code',    :primary_key => 'code'
  
  data_miner do
    tap "Brighter Planet's aircraft data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
