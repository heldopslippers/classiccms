class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_uid
  field :file_name

  file_accessor :file
  validates_property :format, :of => :file, :in => [:jpg, :jpeg, :png, :gif]
end

class Document
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_uid
  field :file_name

  file_accessor :file
  #validates_property :format, :of => :file
end