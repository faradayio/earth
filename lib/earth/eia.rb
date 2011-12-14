module Earth
  module EIA
    extend self

    def normalize(model, fields)
      model.all.each do |record|
        fields.each do |field|
          value = record.send field
          normalized_value = if value == 'Q'
                               0
                             elsif value == 'W'
                               0
                             elsif value == '*'
                               0
                             else
                               value
                             end
          record.send "#{field}=", normalized_value
        end
        record.save
      end
    end
  end
end
