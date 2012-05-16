class Connection
	include Mongoid::Document
  embedded_in :base

	field :order_id,  type: Integer, default: 0
	field	:parent_id, type: BSON::ObjectId
  field :file,      type: String
  field :section,   type: String

  #validations
	validates_numericality_of :order_id, greater_than_or_equal_to: 0
  validate :parent_id_should_exist

	def parent_id_should_exist
    if parent_id != nil and !Base.exists?(conditions: {id: parent_id})
      errors.add :parent_id, "id doesn't exist"
    end
	end
end
