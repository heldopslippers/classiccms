#require 'carrierwave/mongoid'
#
#class Uploader< CarrierWave::Uploader::Base
#  include Mongoid::Document
#  #include CarrierWave::RMagick
#  storage :file
#
#  def filename
#    "#{id}.#{file.extension}" if original_filename.present?
#  end 
#  def extension_white_list
#    %w(jpg jpeg gif png)
#  end
#  def store_dir
#    File.join(Dir.pwd, 'public/assets/images')
#  end
#end
