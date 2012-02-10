module Integration
  def spot_check(records, tests)
    headers = tests.shift
    tests.each do |test|
      where_clause = {}
      headers[0].each_with_index do |field, i|
        where_clause[field] = test[0][i]
      end
      record = records.where(where_clause).first
      headers[1].each_with_index do |field, i|
        record.send(field).should send("be_#{test[1][i]}")
      end
    end
  end
end
