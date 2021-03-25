class AccountRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :account }

  GidDbAry = configurations.configs_for.map(&:name).uniq.join(',').scan(/\d+\b/)

  def self.exec_by_gameid(gid)
    establish_connection(GidDbAry.include?(gid.to_s) ? "account_#{gid}".intern : :account)
    yield GidDbAry
    establish_connection(:account)
    nil
  end

end
