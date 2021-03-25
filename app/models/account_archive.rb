class AccountArchive < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :account_archive }
end
