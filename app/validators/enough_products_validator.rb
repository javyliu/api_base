class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |item|
      product = item.product
      if item.quantity > product.quantity
        #<< is deprecated
        #record.errors[product.title.to_s] << "Is out of stock, just #{product.quantity} left"
        record.errors.add product.title.to_s, "Is out of stock, just #{product.quantity} left"
      end
    end
  end

end
