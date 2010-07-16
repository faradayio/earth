Earth::Database.define_schema do
  create_table "fallbacks", :force => true do |t|
    t.string   "name"
    t.text     "values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  create_table "yearly_anonymous_emissions", :force => true do |t|
    t.string  "component"
    t.integer "year"
    t.float   "emission"
  end
  create_table "yearly_typical_emissions", :force => true do |t|
    t.string  "component"
    t.integer "year"
    t.float   "emission"
  end
end
