ActiveRecord::Schema.define(:version => 1) do
  create_table "fallbacks", :force => true do |t|
    t.string   "name"
    t.text     "values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
