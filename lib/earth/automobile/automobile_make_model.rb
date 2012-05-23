require 'earth/fuel'
class AutomobileMakeModel < ActiveRecord::Base
  self.primary_key = "name"
  
  def model_years
    AutomobileMakeModelYear.where(:make_name => make_name, :model_name => model_name)
  end
  
  def fuel_code
    codes = model_years.map(&:fuel_code).uniq
    if codes.count == 1
      codes.first
    elsif codes.all?{ |code| ['R', 'P', 'G'].include? code }
      'G'
    end
  end
  
  def alt_fuel_code
    codes = model_years.map(&:alt_fuel_code).uniq
    codes.first if codes.count == 1
  end
  
  def method_missing(method_id, *args, &block)
    if method_id.to_s =~ /^(alt_)?fuel_efficiency_(city|highway)$/
      model_years.weighted_average("#{method_id}")
    elsif method_id.to_s =~ /^(alt_)?fuel_efficiency_(city|highway)_units$/
      model_years.first.send(method_id)
    else
      super
    end
  end
  
  col :name
  col :make_name
  col :model_name
end
