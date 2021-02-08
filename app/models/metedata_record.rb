class MetedataRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :metedata }
end
