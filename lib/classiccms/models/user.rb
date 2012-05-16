class User
	include Mongoid::Document

	field :username, type: String
	field :password

	##validations
  validates_uniqueness_of :username
	validates_length_of     :username, minimum: 3, maximum: 25
	validates_length_of     :password, minimum: 3, maximum: 25
end
