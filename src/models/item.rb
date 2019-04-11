class Item
  key :position, Integer
  key :name, String
  key :price, Float

  has_many :pictures
  has_one :color
end
