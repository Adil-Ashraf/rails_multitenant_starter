module AccountScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :account
    default_scope { where(account: Current.account || raise("Current.account is not set")) }
  end
end
