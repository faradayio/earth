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
  end
end
