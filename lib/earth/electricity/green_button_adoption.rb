require 'earth/model'

class GreenButtonAdoption < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "green_button_adoptions"
  (
     "electric_utility_name" CHARACTER VARYING(255) NOT NULL,
     "implemented"           BOOLEAN,
     "committed"             BOOLEAN
  );
ALTER TABLE "green_button_adoptions" ADD PRIMARY KEY ("electric_utility_name")
EOS

  self.primary_key = "electric_utility_name"
  

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
