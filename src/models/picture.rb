class Picture
  key :description, String
  has_media :image
  belongs_to :item

  def crop
    # logic to crop image
  end

  def thumbnail
    # logic to generate thumbnail
  end
end
