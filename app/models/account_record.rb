class AccountRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :account }

  GidDBAry = configurations.configs_for.map(&:name).uniq.join(',').scan(/\d+\b/)

  def self.exec_by_gameid(gid)
    establish_connection(GidDBAry.include?(gid.to_s) ? "account_#{gid}".intern : :account)
    yield GidDBAry
    establish_connection(:account)
    nil
  end

end
