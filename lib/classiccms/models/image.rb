class Image
  include Mongoid::Document

  field :file_uid
  field :file_name

  file_accessor :file
  validates_property :format, :of => :file, :in => [:jpg, :jpeg, :png, :gif]
end
