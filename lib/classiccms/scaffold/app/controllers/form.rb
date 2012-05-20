require 'classiccms/controllers/application'

module Classiccms
  class FormController< ApplicationController
    get '/zomg' do
      'zomg!'
    end
  end
end
