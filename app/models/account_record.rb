class AccountRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :account }
end
