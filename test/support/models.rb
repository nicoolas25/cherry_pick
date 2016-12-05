require_relative "schema"

class City < ActiveRecord::Base
  has_one :mayor
end

class Mayor < ActiveRecord::Base
  belongs_to :city
end
