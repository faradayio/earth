Earth.define_schema do
  create_table "fallbacks", :force => true do |t|
    t.string   "name"
    t.text     "values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
