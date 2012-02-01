require 'earth'

module Earth
  module EIA
    extend self
    
    def convert_value(args)
      case args[:value]
      when '*'
        0
      when 'Q', 'W'
        nil
      else
        args[:value].to_f.send(args[:from_units]).to(args[:to_units])
      end
    end
  end
end
