ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table "cities", force: true do |t|
    t.string :name
    t.datetime :created_at
  end

  create_table "citizens", force: true do |t|
    t.integer :home_city_id
  end

  create_table "mayors", force: true do |t|
    t.integer :beloved_city_id
  end

  create_table "subways", force: true do |t|
  end

  create_table "cities_subways", force: true do |t|
    t.integer :city_id
    t.integer :subway_id
  end
end
