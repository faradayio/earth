require 'spec_helper'
require 'earth/model'

class FooBaloo < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = "CREATE TABLE foo_baloos (id integer);"

  data_miner {}
end

describe Earth::Model do
  it 'manages its Schema' do
    expect { FooBaloo.create_table! }.not_to raise_error
  end
  it 'has SafeFinders' do
    FooBaloo.should respond_to(:safe_find_in_batches)
    FooBaloo.should respond_to(:safe_find_each)
  end

  describe '#registry' do
    it 'catalogues each Earth model' do
      Earth::Model.registry.should include(FooBaloo)
    end
  end
end

