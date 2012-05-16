#require "classicCMS/base"
Dir[File.join(File.dirname(__FILE__), 'classicCMS/models/*.rb')].each {|file| require file }

module Classiccms
end
