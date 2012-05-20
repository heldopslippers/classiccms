require 'mongoid'

class Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia

  #associations
  embeds_many :connections
  accepts_nested_attributes_for :connections

  after_destroy :remove_slugs
  after_destroy :remove_connections


  def remove_slugs
    Slug.where(:document_id => id).destroy
  end
  def remove_connections
    records = Base.where(:'connections.parent_id' => id)
    records.each do |record|
      record.connections.where(:parent_id => id).destroy_all
    end
  end
end
