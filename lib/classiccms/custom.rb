class ImageField
  #include Mongoid::Fields::Serializable

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      Image.find(object).file
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when BSON::ObjectId then object
      else BSON::ObjectId(object)
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
  end
end

