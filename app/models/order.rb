class Order < ApplicationRecord
  validates_with EnoughProductsValidator
  belongs_to :user

  validates :total, numericality: {greater_than_or_equal_to: 0}
  validates :total, presence: true
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  before_validation :set_total!

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |item|
      placement = placements.build(product_id: item[:product_id], quantity: item[:quantity])
      yield placement if block_given?
    end
  end


  def set_total!
    self.total = placements.map do |item|
      item.quantity * item.product.price
    end.sum
  end
end
