require 'classiccms/models/uploader.rb'
class Image
  include Mongoid::Document

  mount_uploader :image, Uploader
end
