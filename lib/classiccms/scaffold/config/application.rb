module Classiccms
  set :session_secret, 'a6d49bfcafc6ac1cae95c0b55c1069f6cc57b7866b6a6b7c1ed23dd09ad4c8c1'
  $app = Dragonfly[:file].configure_with(:imagemagick)
  $app.define_macro_on_include(Mongoid::Document, :file_accessor)  
  $app.server.url_format = '/files/:job/:basename.:format'
  $app.configure do |c|
    c.allow_fetch_file = true
  end
end