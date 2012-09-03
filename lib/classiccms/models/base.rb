require 'mongoid'
Mongoid::Fields.option :input do |model, field, value|
  #model.validates_presence_of field if value
end
Mongoid::Fields.option :options do |model, field, value|
  #model.validates_presence_of field if value
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
