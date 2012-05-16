require 'mongoid'

class Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia

  #associations
  embeds_many :connections
  accepts_nested_attributes_for :connections
end
