class OrderSerializer
  include JSONAPI::Serializer
  #attributes
  belongs_to :user
  has_many :products
end
