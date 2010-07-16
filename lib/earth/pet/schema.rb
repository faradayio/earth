Earth::Database.define_schema do
  create_table "genders", :primary_key => "name", :id => false, :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
