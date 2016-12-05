ActiveRecord::Schema.define(version: 1) do
  create_table "cities", force: true do |t|
  end

  create_table "mayors", force: true do |t|
    t.integer :city_id
  end
end
