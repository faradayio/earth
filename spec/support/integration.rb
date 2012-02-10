module Integration
  def spot_check(records, tests)
    headers = tests.shift
    tests.each do |test|
      where_clause = {}
      headers[0].each_with_index do |field, i|
        where_clause[field] = test[0][i]
      end
      record = records.where(where_clause).first
      record.should_not be_nil, "Expected to find a record with #{where_clause.inspect}"
      headers[1].each_with_index do |field, i|
        criterion = test[1][i]
        record.send(field).should send("be_#{criterion}"), "Expecting #{field} to be #{criterion} on #{record.inspect}"
      end
    end
  end
end
