require 'cgi'

class Slug
	include Mongoid::Document
  identity :type => String
	field :document_id, type: BSON::ObjectId

  #validations
  validate :document_id_should_exist

  def document_id_should_exist
    if !Base.exists?(conditions: {id: document_id})
      errors.add :document_id, "id doesn't exist"
    end
  end

  def generate_id
    i = 0
    i+=1 while Slug.exists? conditions: {id: i.to_s}
    self.id = i.to_s
  end
  def set_id(url)
    Slug.where(id: url).delete_all
    self.id = url.gsub(/[^a-zA-Z0-9\-\/]+/, '-').downcase
  end
end
