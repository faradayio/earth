class GreenButtonAdoption < ActiveRecord::Base
  self.primary_key = "electric_utility_name"
  
  col :electric_utility_name
  col :implemented, :type => :boolean
  col :committed, :type => :boolean

  class << self
    def implemented?(*names)
      names.any? do |name|
        find_by_electric_utility_name(name).try :implemented?
      end
    end
    def committed?(*names)
      names.any? do |name|
        find_by_electric_utility_name(name).try :committed?
      end
    end
  end
end
