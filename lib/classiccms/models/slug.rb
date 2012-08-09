require 'cgi'

class Slug
	include Mongoid::Document
  field :_id, :type => String
	field :document_id, type: Moped::BSON::ObjectId

  #validations
  validate :document_id_should_exist

  def document_id_should_exist
    if !Base.where(_id: document_id).exists?
      errors.add :document_id, "id doesn't exist"
    end
  end

  def generate_id
    i = 0
    i+=1 while Slug.where(_id: i.to_s).exists?
    self.id = i.to_s
  end
  def set_id(url)
    Slug.delete_all(_id: url)
    self._id = url.gsub(/[^a-zA-Z0-9\-\/]+/, '-').downcase
  end
end
