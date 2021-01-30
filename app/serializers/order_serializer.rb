class OrderSerializer
  include JSONAPI::Serializer
  #attributes
  belongs_to :user
  has_many :products
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 30.minutes
end
