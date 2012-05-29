class ImageField
  include Mongoid::Fields::Serializable

  def deserialize(object)
    Image.find(object).file
  end

  def serialize(object)
    if object.class == BSON::ObjectId
      return object
    else
      return BSON::ObjectId(object)
    end
  end
end

