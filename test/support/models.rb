require_relative "schema"

class City < ActiveRecord::Base
  has_one :mayor, foreign_key: :beloved_city_id
  has_many :citizens, foreign_key: "home_city_id"
  has_and_belongs_to_many :subways
end

class Mayor < ActiveRecord::Base
  belongs_to :beloved_city, class_name: "City"
end

class Subway < ActiveRecord::Base
  has_and_belongs_to_many :cities
end

class Citizen < ActiveRecord::Base
  belongs_to :home_city, class_name: "City"
end
