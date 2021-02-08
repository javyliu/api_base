class PipstatRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :pipstat }
end
