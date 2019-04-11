class Item
  has_media :picture
  key :picture_description, String
  key :position, Integer
  key :name, String
  key :price, Float
  key :color, String

  def rgb_color
    # logic to convert HEX color to RGB
  end

  def color_gradient
    # logic to generate a gradient from the color
  end

  def crop_picture
    # logic to crop the picture
  end

  def thumbnail
    # logic to generate thumbnail of picture
  end

  # many other methods regarding Items
end
