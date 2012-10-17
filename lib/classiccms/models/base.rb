require 'mongoid'
Mongoid::Fields.option :input do |model, field, value|
  #model.validates_presence_of field if value
end
Mongoid::Fields.option :options do |model, field, value|
  #model.validates_presence_of field if value
end
class ImageType
  attr_reader :image_id

  def initialize(image_id)
    @image_id
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object_id)
      image = Image.where(:id => object_id).first
      if image != nil
        image.file
      else
        Dragonfly[:file].fetch_file(File.join(Dir.pwd, 'public/not_found.jpeg'))
      end
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object_id)
      object_id
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when ImageType then object.mongoize
      else object
      end
    end
  end
end
class DocumentType
  attr_reader :document_id

  def initialize(document_id)
    @document_id
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object_id)
      document = Document.where(:id => object_id).first
      if document != nil
        document.file
      else
        Dragonfly[:file].fetch_file(File.join(Dir.pwd, 'public/not_found.jpeg'))
      end
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object_id)
      object_id
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when FileType then object.mongoize
      else object
      end
    end
  end
end

class Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia
  include Mongoid::MultiParameterAttributes

  #associations
  embeds_many :connections
  accepts_nested_attributes_for :connections

  after_destroy :remove_slugs
  after_destroy :remove_connections


  def remove_slugs
    Slug.delete_all(:document_id => id)
  end
  def remove_connections
    records = Base.where(:'connections.parent_id' => id)
    records.each do |record|
      record.connections.where(:parent_id => id).destroy_all
    end
  end
end
