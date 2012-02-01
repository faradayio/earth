require 'earth'

module Earth
  module EIA
    extend self
    
    def normalize(model, fields)
      model.all.each do |record|
        fields.each do |k|
          v = record.send k
          normalized_v = case v
          when 'Q', 'W', '*'
            0
          else
            v
          end
          record.send "#{k}=", normalized_v
        end
        record.save!
      end
    end
    
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
