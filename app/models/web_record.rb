class WebRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :web }
end
